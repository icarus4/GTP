// webpack --config frontend/development.config.js --display-reasons --display-chunks --progress --color
var path = require('path');
var _ = require('lodash');
var webpack = require('webpack');
var assetPath = path.join(__dirname, '../', 'public', 'assets');
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var ManifestPlugin = require('webpack-manifest-plugin');

var config = module.exports = {
  context: path.join(__dirname, '../'),

  // 告訴 webpack 去哪裡找 entry 文件
  // webpack 按需加載和打包裡面使用的 module，這裡用 CommonJS/AMD/ES6 的語法都可以
  entry: './frontend/javascripts/app.js',

  // 開發環境 debug 的一些配置
  debug: true,
  displayErrorDetails: true,
  outputPathinfo: true,
  devtool: 'cheap-module-eval-source-map'
};

config.output = {
  path: assetPath,

  // 打包出來的文件會是 [文件名]_bundle.js
  // 比如我們的 entry 叫 app.js，打包出來的文件就是 app_bundle.js
  filename: '[name]_bundle.js',
  publicPath: '/assets/'
};

config.resolve = {
  extensions: ['', '.js', '.coffee', '.json'],
  modulesDirectories: ['node_modules'],
  root: path.resolve(__dirname),
};

config.plugins = [
  // 如果多個文件裡使用了 jquery，以下這個 plugin 可以讓你不用每次都 require('jquery')
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  }),

  // 用來抽取 js 文件裡引用的 css 文件，最終的文件名也會是 [js文件名]_bundle.css 的形式
  new ExtractTextPlugin('[name]_bundle.css', {
    allChunks: true
  }),

  // 產生 fingerprint path name
  new ManifestPlugin({
    fileName: 'webpack_manifest.json'
  })
];

// webpack 強大的 loader
config.module = {
  loaders: [
    // 下面兩行將 jquery 暴露到外面的 $ 和 jQuery 裡，這樣 webpack 以外的 js 也可以順利使用 jquery
    {test: require.resolve("jquery"), loader: "expose?jQuery" },
    {test: require.resolve("jquery"), loader: "expose?$" },

    // 使用 babel-loader 來支持 es6 語法
    {test: /\.js$/, loader: 'babel-loader'},

    // 使用 coffee-loader 來編譯 CoffeeScript
    {test: /\.coffee$/, loader: 'coffee-loader'},

    // 使用 url-loader 來編譯字體文件和圖片，如果文件小於8kb就直接變成 DataUrl
    {test: /\.(woff|woff2|eot|ttf|otf)\??.*$/, loader: 'url-loader?limit=8192&name=[name].[ext]'},
    {test: /\.(jpe?g|png|gif|svg)\??.*$/, loader: 'url-loader?limit=8192&name=[name].[ext]'},

    // 使用 style-loader、css-loader 來打包 css，sass-loader 打包 sass
    // 使用 ExtractTextPLugin 生成獨立的 css 文件
    {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css-loader')},
    {test: /\.scss$/, loader: ExtractTextPlugin.extract('style', 'css!sass')}
  ]
};
