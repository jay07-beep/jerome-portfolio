import { readFileSync } from "node:fs";
import { join } from "node:path";
import { withBasePath } from "../../site-path";

export default function AirlineDatabaseCode() {
  const sqlCode = readFileSync(
    join(process.cwd(), "app/projects/airline-database/airline-database.sql"),
    "utf8",
  );
  const lines = sqlCode.trimEnd().split("\n");

  return (
    <main className="sql-page">
      <header className="sql-toolbar">
        <a href={withBasePath("/")}>← Portfolio</a>
        <div>
          <strong>Airline SQL Database</strong>
          <span>{lines.length.toLocaleString("en-US")} lines · MariaDB / MySQL</span>
        </div>
      </header>
      <div className="sql-code-frame" aria-label="Complete SQL source code">
        <pre className="sql-code"><code>{lines.map((line, index) => (
          <span className="sql-line" key={index}>
            <span className="line-number" aria-hidden="true">{index + 1}</span>
            <span>{line || " "}</span>
          </span>
        ))}</code></pre>
      </div>
    </main>
  );
}
