import { getTranslation } from '@/app/i18n';
import { Header } from '@/components/header/Header';
import styles from './page.module.scss';

interface HomeProps {
  params: Promise<{ lng: string }>;
}

export default async function Home({ params }: HomeProps) {
  const lng = (await params).lng;
  const { t } = await getTranslation(lng, 'common');

  return (
    <div className={styles.page}>
      <main className={styles.main}>
        <Header />
      </main>
    </div>
  );
}
