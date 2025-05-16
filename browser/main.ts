import * as z from "@zod/mini";

import { sayHi } from "./utils.js";

const mySchema = z.nullable(z.optional(z.string()));

const result = mySchema.safeParse("hi");

if (result.success) {
  console.log("Valid data:", result.data);
  sayHi();
} else {
  const issues = result.error.issues;
  for (const issue of issues) {
    console.error("Validation Error:", issue);
  }
}
