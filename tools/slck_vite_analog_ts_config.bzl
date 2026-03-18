load("@bazel_skylib//rules:write_file.bzl", "write_file")

def slck_vite_analog_ts_config(name):
    root = "".join(["../"] * len(native.package_name().split("/")))

    write_file(
        name = name,
        out = "tsconfig.app.json",
        content = ["""
            {
                "compileOnSave": false,
                "compilerOptions": {
                    "paths": {
                      "@slck/*": ["%spackages/ng/*"]
                    },
                    "baseUrl": "./",
                    "outDir": "./dist/out-tsc",
                    "forceConsistentCasingInFileNames": true,
                    "strict": true,
                    "noImplicitOverride": true,
                    "noPropertyAccessFromIndexSignature": true,
                    "noImplicitReturns": true,
                    "noFallthroughCasesInSwitch": true,
                    "sourceMap": true,
                    "declaration": false,
                    "downlevelIteration": true,
                    "experimentalDecorators": true,
                    "moduleResolution": "node",
                    "importHelpers": true,
                    "noEmit": false,
                    "target": "es2020",
                    "module": "es2020",
                    "lib": ["es2020", "dom"],
                    "skipLibCheck": true
                },
                "angularCompilerOptions": {
                    "enableI18nLegacyMessageIdFormat": false,
                    "strictInjectionParameters": true,
                    "strictInputAccessModifiers": true,
                    "strictTemplates": true
                },
                "files": [],
                "include": [
                    "./**/*.ts",
                    "%spackages/**/*.ts"
                ]
            }
        """ % (
            root,
            root,
        )],
        tags = ["vite"],
    )
