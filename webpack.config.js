const path = require('path');

module.exports = {
    mode: 'development',
    entry: './src/xzwasm.js',
    devtool: false,
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'dist/package'),
        library: {
            name: 'xzwasm',
            type: 'var',
        }
    },
}
