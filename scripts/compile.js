const fs = require("node:fs");
const path = require("node:path");
const solc = require("solc");

const root = path.resolve(__dirname, "..");
const buildDir = path.join(root, "build");

function compileAll() {
  const files = fs.readdirSync(root).filter((file) => file.endsWith(".sol"));
  const sources = Object.fromEntries(
    files.map((file) => [file, { content: fs.readFileSync(path.join(root, file), "utf8") }]),
  );
  const input = {
    language: "Solidity",
    sources,
    settings: { outputSelection: { "*": { "*": ["abi", "evm.bytecode.object"] } } },
  };
  const output = JSON.parse(solc.compile(JSON.stringify(input)));
  const diagnostics = output.errors ?? [];

  diagnostics.forEach((item) => console[item.severity === "error" ? "error" : "warn"](item.formattedMessage));
  if (diagnostics.some((item) => item.severity === "error")) {
    throw new Error("Solidity compilation failed");
  }

  fs.rmSync(buildDir, { recursive: true, force: true });
  fs.mkdirSync(buildDir, { recursive: true });
  const contracts = [];

  for (const sourceContracts of Object.values(output.contracts ?? {})) {
    for (const [contractName, artifact] of Object.entries(sourceContracts)) {
      fs.writeFileSync(
        path.join(buildDir, `${contractName}.json`),
        `${JSON.stringify({ contractName, abi: artifact.abi, bytecode: artifact.evm.bytecode.object }, null, 2)}\n`,
      );
      contracts.push(contractName);
    }
  }

  console.log(`Compiled ${contracts.length} contract(s): ${contracts.join(", ")}`);
  return contracts;
}

if (require.main === module) compileAll();
module.exports = { compileAll };
