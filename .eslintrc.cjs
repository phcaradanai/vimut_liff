module.exports = {
    env: {
        browser: true,
        node: true,
        es2021: true,
    },
    extends: ["plugin:vue/vue3-recommended", "standard", "prettier"],
    parser: "vue-eslint-parser",
    overrides: [
        {
            files: ["*.html"],
            rules: {
                "vue/comment-directive": "off",
            },
        },
    ],
    parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
    },
    plugins: ["vue"],
    rules: {
        "arrow-parens": 0,
        "generator-star-spacing": 0,
        "no-debugger": process.env.NODE_ENV === "production" ? 2 : 0,
        "comma-dangle": [2, "always-multiline"],
        "space-before-function-paren": 0,
        "object-curly-spacing": 1,
        "prefer-const": 0,
        "no-unneeded-ternary": ["error", { defaultAssignment: true }],
        "vue/max-attributes-per-line": 0,
        "vue/attributes-order": 0,
        "vue/require-default-prop": 0,
        "no-control-regex": 0,
        "vue/multi-word-component-names": 0,
        "vue/html-self-closing": 0,
        "vue/script-setup-uses-vars": 1,
    },
};
