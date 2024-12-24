import { getTranslation } from '@/app/i18n';
import styles from './page.module.css';

interface HomeProps {
  params: Promise<{ lng: string }>;
}

export default async function Home({ params }: HomeProps) {
  const lng = (await params).lng;
  const { t } = await getTranslation(lng, 'common');
  return (
    <div className={styles.page}>
      <main className={styles.main}>
        <h1>{t('title')}</h1>
      </main>
      <footer className={styles.footer}>
        <h1>{t('title')}</h1>
      </footer>
    </div>
  );
}
