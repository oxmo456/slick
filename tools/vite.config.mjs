import {defineConfig} from 'vite';
import * as path from 'path';
import inspect from 'vite-plugin-inspect';
import angularAnalogJsPlugin from '@analogjs/vite-plugin-angular';

export default defineConfig({
    root: process.env['ROOT'],
    resolve: {
        conditions: ['module'],
        alias: {
            '@nnm': path.resolve(process.cwd(), 'packages/ng/')
        }
    },
    css: {
        preprocessorOptions: {
            scss: {}
        }
    },
    plugins: [
        inspect(),
        angularAnalogJsPlugin({
            tsconfig: 'tsconfig.app.json'
        })
    ],
    test: {
        globals: true,
        environment: 'jsdom',
        setupFiles: ['./test-setup.ts'],
        include: ['./**/*.spec.ts'],
        reporters: ['default'],
        server: {
            deps: {
                inline: [/@angular/]
            }
        }
    }
});
