const path = require('path');
const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
    mode: 'none',
    entry: {
        'xzwasm': './src/xzwasm.js',
        'xzwasm.min': './src/xzwasm.js',
    },
    devtool: false,
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'dist/package'),
        library: {
            name: 'xz',
            type: 'var',
        }
    },
    module: {
        rules: [{
            test: /\.wasm/,
            type: 'asset/inline'
        }]
    },
    optimization: {
        minimize: true,
        minimizer: [new TerserPlugin({ include: /\.min\.js$/, extractComments: false })]
    },
    plugins: [
        new webpack.BannerPlugin({
            banner: ''
                + 'xzwasm (c) Steve Sanderson. License: MIT - https://github.com/SteveSanderson/xzwasm\n'
                + 'Contains xz-embedded by Lasse Collin and Igor Pavlov. License: Public domain - https://tukaani.org/xz/embedded.html\n'
                + 'and walloc (c) 2020 Igalia, S.L. License: MIT - https://github.com/wingo/walloc'
        })
    ]
}
