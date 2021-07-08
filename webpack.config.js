const path = require('path');

module.exports = {
    mode: 'development',
    entry: './src/xzwasm.js',
    devtool: false,
    output: {
        filename: 'xzwasm.js',
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
    }
}
