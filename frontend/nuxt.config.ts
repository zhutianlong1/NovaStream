// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  runtimeConfig: {
    public: {
      apiBaseUrl: "/api"
    }
  },
  nitro: {
    devProxy: {
      "/api": {
        target: "http://localhost:8080",
        changeOrigin: true,
        prependPath: false,
      }
    }
  }
})