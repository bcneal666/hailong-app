'use client';
import { Button, List } from '@react95/core';
import { FolderOpen } from '@react95/icons';
import { useEffect, useRef, useState } from 'react';

export const Menu = () => {
  const [isOpen, setIsOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  return (
    <div ref={menuRef} style={{ position: 'relative' }}>
      <Button onClick={() => setIsOpen((prev) => !prev)}>
        <FolderOpen variant="32x32_4" style={{ cursor: 'pointer' }} />
      </Button>
      {isOpen && (
        <List style={{ position: 'absolute', top: '60px', right: 0 }}>
          <List.Item
            icon={
              <FolderOpen variant="32x32_4" style={{ cursor: 'pointer' }} />
            }
          >
            Accessories
          </List.Item>
          <List.Item
            icon={
              <FolderOpen variant="32x32_4" style={{ cursor: 'pointer' }} />
            }
          >
            Accessories
          </List.Item>
          <List.Item
            icon={
              <FolderOpen variant="32x32_4" style={{ cursor: 'pointer' }} />
            }
          >
            Accessories
          </List.Item>
        </List>
      )}
    </div>
  );
};
