import { Avatar } from '@react95/core';

interface RAvatarProps {
  src: string;
  alt: string;
  size: number;
  type?: 'circle' | 'normal';
}

export const RAvatar = ({ src, alt, size, type = 'normal' }: RAvatarProps) => {
  const typeProps = type === 'circle' ? { circle: true } : {};
  return <Avatar src={src} alt={alt} size={`${size}px`} {...typeProps} />;
};
