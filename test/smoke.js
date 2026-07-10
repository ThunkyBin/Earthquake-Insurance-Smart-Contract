const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const { compileAll } = require("../scripts/compile");

const contracts = compileAll();
assert.ok(contracts.includes("EarthquakeInsurance"), "EarthquakeInsurance artifact was not generated");

const artifact = JSON.parse(
  fs.readFileSync(path.join(__dirname, "..", "build", "EarthquakeInsurance.json"), "utf8"),
);
const functions = new Set(artifact.abi.filter((item) => item.type === "function").map((item) => item.name));

for (const expected of ["buyInsurance", "processPayout", "withdraw", "premium"]) {
  assert.ok(functions.has(expected), `Missing ABI function: ${expected}`);
}

console.log("EarthquakeInsurance ABI smoke test passed.");
