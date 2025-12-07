import { ThemeProvider } from '@mui/material/styles';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { lightTheme } from './theme';
import Layout from './components/common/Layout';
import ConnectionsPage from './pages/ConnectionsPage';
import BrowserPage from './pages/BrowserPage';
import QueryPage from './pages/QueryPage';
import ETLPage from './pages/ETLPage';

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={lightTheme}>
        <BrowserRouter>
          <Layout>
            <Routes>
              <Route path="/" element={<Navigate to="/connections" replace />} />
              <Route path="/connections" element={<ConnectionsPage />} />
              <Route path="/browser" element={<BrowserPage />} />
              <Route path="/query" element={<QueryPage />} />
              <Route path="/etl" element={<ETLPage />} />
            </Routes>
          </Layout>
        </BrowserRouter>
      </ThemeProvider>
    </QueryClientProvider>
  );
}

export default App;
