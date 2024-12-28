import { RAvatar, RFrame } from '@/components';
import styles from './header.module.scss';
import { Menu } from './Menu';

export const Header = () => {
  return (
    <RFrame className={styles.header}>
      <div className={styles.left}>
        <RAvatar
          src="https://github.com/React95.png"
          alt="avatar"
          size={30}
          type="circle"
        />
        <p className={styles.title}>React95</p>
      </div>
      <div className={styles.right}>
        <Menu />
      </div>
    </RFrame>
  );
};
