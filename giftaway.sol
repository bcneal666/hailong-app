// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Giftaway {
    error LessThanPrice();
    error DrawTimePassed();
    error DrawTimeNotArrived();
    error LotteryNotOpen();
    error LotteryAlreadyClosed();
    error BalanceIsZero();
    error NotWinner();
    error WithdrawPrizeFailed();

    address private immutable owner;
    uint256 public immutable ticketPrice;
    uint256 public immutable drawTime;
    mapping(uint256 => uint256) private secretToPercent;

    uint256 public IS_LOTTERY_OPEN = 0;
    uint256 public FINAL_BALANCE = 0;

    constructor(
        uint256 _drawTime,
        uint256 _ticketPrice,
        uint256[4] memory _prizeSecrets
    ) {
        ticketPrice = _ticketPrice;
        drawTime = _drawTime;
        secretToPercent[_prizeSecrets[0]] = 35;
        secretToPercent[_prizeSecrets[1]] = 20;
        secretToPercent[_prizeSecrets[2]] = 15;
        secretToPercent[_prizeSecrets[3]] = 10;
        owner = msg.sender;
    }

    event GetTicketsEvent(address indexed buyer, uint256 count);

    event LotteryEvent(
        address indexed caller,
        uint256 indexed lotteryTime,
        uint256 randomSeed
    );
    event ClaimPrizeEvent(address indexed winner, uint256 prize);

    function getTickets() external payable {
        if (msg.value < ticketPrice || msg.value % ticketPrice != 0) {
            revert LessThanPrice();
        }
        if (block.timestamp >= drawTime) revert DrawTimePassed();

        uint256 count = msg.value / ticketPrice;
        emit GetTicketsEvent(msg.sender, count);
    }

    function triggerLottery() external {
        if (block.timestamp < drawTime) revert DrawTimeNotArrived();
        if (IS_LOTTERY_OPEN == 1) revert LotteryAlreadyClosed();
        if (address(this).balance == 0) revert BalanceIsZero();

        uint256 randomSeed = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    msg.sender,
                    address(this).balance
                )
            )
        );
        IS_LOTTERY_OPEN = 1;
        FINAL_BALANCE = address(this).balance;
        emit LotteryEvent(msg.sender, block.timestamp, randomSeed);
    }

    function claimPrize(uint256 prizeSecret) external {
        if (IS_LOTTERY_OPEN != 1) revert LotteryNotOpen();
        uint256 balance = FINAL_BALANCE;
        if (balance == 0) revert BalanceIsZero();

        uint256 prizePercent = secretToPercent[prizeSecret];
        if (prizePercent == 0) revert NotWinner();

        uint256 prize = (balance * prizePercent) / 100;
        (bool success, ) = msg.sender.call{value: prize}("");
        if (!success) revert WithdrawPrizeFailed();
        emit ClaimPrizeEvent(msg.sender, prize);
    }

    function balanceOf() external view returns (uint256) {
        return address(this).balance;
    }
    function prizeSumBalanceOf() public view returns (uint256) {
        return (address(this).balance * 70) / 100;
    }

    function withdraw() external {
        require(msg.sender == owner);
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success);
    }
}
