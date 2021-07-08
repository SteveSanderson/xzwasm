const path = require('path');
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
        minimizer: [new TerserPlugin({ include: /\.min\.js$/ })]
    }
}
