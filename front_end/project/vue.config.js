// const { defineConfig } = require('@vue/cli-service')
// module.exports = defineConfig({
//   transpileDependencies: true,
//   lintOnSave: false 
// })


const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  devServer: {
    port: 8081,  // 你想要的端口，可以修改为任意未被占用的端口
    open: true   // 可选项，设置为 true 会在启动时自动打开浏览器
  }
})
