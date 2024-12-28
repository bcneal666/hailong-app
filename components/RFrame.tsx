import { Frame } from '@react95/core';

interface IFrameProps {
  children: React.ReactNode;
  w?: string;
  h?: string;
  className?: string;
}

export const RFrame = ({
  children,
  w = '100%',
  h = '60px',
  className,
}: IFrameProps) => {
  return (
    <Frame
      bgColor="$material"
      boxShadow="$out"
      w={w}
      h={h}
      className={className}
    >
      {children}
    </Frame>
  );
};
