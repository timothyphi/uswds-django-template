import globals from "globals";
import pluginJs from "@eslint/js";
import pluginTsEsLint from "typescript-eslint";
import pluginSecurity from "eslint-plugin-security";
import { Linter } from "eslint";

const config: Linter.Config[] = [
  { files: ["**/*.ts"] },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  pluginSecurity.configs.recommended,
  ...(pluginTsEsLint.configs.recommended as Linter.Config[]),
];

export default config;
