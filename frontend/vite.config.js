import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  // environment variables
  define: {
    VITE_API_BASE_URL: JSON.stringify(process.env.VITE_API_BASE_URL || 'https://j-kart.bytexl.live/api')
  },
})
