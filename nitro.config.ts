// https://nitro.unjs.io/config
export default defineNitroConfig({
  srcDir: "server",
  storage: {
    vercelKV: { driver: 'vercelKV' }
  }
})
