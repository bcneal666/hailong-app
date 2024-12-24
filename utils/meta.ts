import { Metadata, Viewport } from 'next';

// 将 viewport 配置分离出来
export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
};

export const defaultMeta: Metadata = {
  title: 'Hailong',
  description: 'Hailong',
  keywords: ['Hailong', 'Hailong', 'Hailong'],
  referrer: 'origin',
  openGraph: {
    type: 'website',
    title: 'Hailong',
    description: 'Hailong',
    url: 'https://hailong.com',
    siteName: 'Hailong',
    // images: ['https://hailong.com/og.png'],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Hailong',
    description: 'Hailong',
    // images: ['https://Hailong.com/og.png'],
  },
};
