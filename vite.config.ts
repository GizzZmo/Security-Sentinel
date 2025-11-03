import path from 'path';
import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, '.', '');
    return {
      base: env.VITE_BASE || '/',
      plugins: [react()],
      define: {
        'process.env.GEMINI_API_KEY': JSON.stringify(env.GEMINI_API_KEY)
      },
      resolve: {
        alias: {
          '@': path.resolve(__dirname, '.'),
        }
      },
      build: {
        outDir: 'dist',
        assetsDir: 'assets',
        sourcemap: true,
        minify: 'esbuild',
        target: 'es2020',
        lib: process.env.BUILD_MODE === 'lib' ? {
          entry: resolve(__dirname, 'index.tsx'),
          name: 'SecuritySentinelWeb',
          fileName: 'security-sentinel-web',
          formats: ['es', 'umd']
        } : undefined,
        rollupOptions: {
          external: process.env.BUILD_MODE === 'lib' ? ['react', 'react-dom'] : [],
          output: process.env.BUILD_MODE === 'lib' ? {
            globals: {
              react: 'React',
              'react-dom': 'ReactDOM'
            }
          } : {
            manualChunks: {
              'vendor': ['react', 'react-dom'],
              'charts': ['recharts'],
              'ai': ['@google/genai']
            }
          }
        },
        chunkSizeWarningLimit: 1000
      }
    };
});
