// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Giftaway {
    error NotOwner();
    error MustBeInTheFuture();
    error LessThanPrice();
    error DrawTimePassed();
    error DrawTimeNotArrived();
    error LotteryNotOpen();
    error LotteryAlreadyClosed();
    error BalanceIsZero();
    error SendPrizeFailed();
    error WithdrawFailed();

    address private immutable owner;
    uint256 public immutable ticketPrice;
    uint256 public immutable drawTime;
    uint256 public NOW_TICKET_NUMBER = 0;
    uint256 public IS_LOTTERY_OPEN = 0;

    constructor(uint256 _drawTime, uint256 _ticketPrice) {
        if (_drawTime <= block.timestamp) revert MustBeInTheFuture();
        ticketPrice = _ticketPrice;
        drawTime = _drawTime;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function _generateRandomSeed() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.prevrandao,
                        msg.sender,
                        address(this).balance
                    )
                )
            );
    }

    event TicketsPurchased(
        address indexed buyer,
        uint256 count,
        uint256[] numbers
    );

    event LotteryResult(
        address indexed caller,
        uint256 indexed lotteryTime,
        uint256[3] winNumbers
    );

    function getTickets() external payable {
        if (msg.value < ticketPrice || msg.value % ticketPrice != 0) {
            revert LessThanPrice();
        }
        if (block.timestamp >= drawTime) revert DrawTimePassed();

        uint256 count = msg.value / ticketPrice;
        uint256[] memory numbers = new uint256[](count);
        uint256 tempNumber = NOW_TICKET_NUMBER;
        for (uint256 i = 0; i < count; i++) {
            tempNumber++;
            numbers[i] = tempNumber;
        }
        NOW_TICKET_NUMBER = tempNumber;
        emit TicketsPurchased(msg.sender, count, numbers);
    }

    function startLottery() external {
        if (block.timestamp < drawTime) revert DrawTimeNotArrived();
        if (IS_LOTTERY_OPEN == 1) revert LotteryAlreadyClosed();
        if (address(this).balance == 0) revert BalanceIsZero();

        uint256 randomSeed = _generateRandomSeed();
        uint256[3] memory numbers;
        uint256 count;
        for (uint256 i = 0; i < 10 && count < 3; i++) {
            uint256 number = (uint256(
                keccak256(abi.encodePacked(randomSeed, i))
            ) % NOW_TICKET_NUMBER) + 1;

            if (!_contains(numbers, number, count)) {
                numbers[count] = number;
                count++;
            }
        }
        IS_LOTTERY_OPEN = 1;
        emit LotteryResult(msg.sender, block.timestamp, numbers);
    }

    function _contains(
        uint256[3] memory arr,
        uint256 value,
        uint256 length
    ) private pure returns (bool) {
        for (uint256 i = 0; i < length; i++) {
            if (arr[i] == value) return true;
        }
        return false;
    }

    function sendPrize(address[] calldata _winners) external onlyOwner {
        if (IS_LOTTERY_OPEN != 1) revert LotteryNotOpen();
        uint256 balance = address(this).balance;
        if (balance == 0) revert BalanceIsZero();

        uint256[4] memory winPrizes = [
            (balance * 10) / 100,
            (balance * 30) / 100,
            (balance * 20) / 100,
            (balance * 10) / 100
        ];

        for (uint256 i = 0; i < _winners.length; i++) {
            (bool success, ) = _winners[i].call{value: winPrizes[i]}("");
            if (!success) revert SendPrizeFailed();
        }
    }

    function balanceOf() external view returns (uint256) {
        return address(this).balance;
    }
    function prizeSumBalanceOf() public view returns (uint256) {
        return (address(this).balance * 70) / 100;
    }
    function withdraw() external onlyOwner {
        if (IS_LOTTERY_OPEN != 1) revert LotteryNotOpen();
        if (address(this).balance == 0) revert BalanceIsZero();

        (bool success, ) = owner.call{value: address(this).balance}("");
        if (!success) revert WithdrawFailed();
    }
}
