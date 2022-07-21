import { defineConfig } from "windicss/helpers"

export default defineConfig({
  plugins: [
    require("windicss/plugin/line-clamp"),
    require("windicss/plugin/forms"),
    // ...
  ],
})
