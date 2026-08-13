import { withBasePath } from "../../site-path";

export default function SoccerHealthCaseStudy() {
  return (
    <main className="case-page">
      <nav className="case-nav"><a href={withBasePath("/")}>← Portfolio</a><span className="status-pill">Completed prototype</span></nav>
      <header className="case-hero soccer-case-hero"><p className="eyebrow"><span /> Data Engineering · Sports Science</p><h1>Soccer Health<br />Monitor</h1><p>A transparent platform for exploring the relationship between training load, player wellness and reported injury signals in elite football.</p></header>
      <section className="case-metrics"><div><strong>50</strong><span>anonymised players</span></div><div><strong>17,008</strong><span>wellness reports</span></div><div><strong>162</strong><span>injury reports</span></div><div><strong>0.76</strong><span>readiness MAE</span></div></section>
      <section className="case-section two-column"><div><p className="eyebrow"><span /> Project question</p><h2>Can daily data help staff interpret workload and wellness trends?</h2></div><div><div className="soccer-question-text"><p>Professional teams collect both objective sensor data and subjective feedback. The challenge is turning these heterogeneous reports into indicators that are understandable, reproducible and careful about uncertainty.</p><p>The project uses SoccerMon, an anonymised open dataset collected from two teams in Norway&apos;s elite women&apos;s league during the 2020 and 2021 seasons.</p><div className="source-links"><a href="https://www.nature.com/articles/s41597-024-03386-x" target="_blank" rel="noreferrer">Scientific paper ↗</a><a href="https://zenodo.org/records/10033832" target="_blank" rel="noreferrer">Dataset ↗</a></div></div></div></section>
      <section className="case-section soccer-work-section">
        <p className="eyebrow"><span /> The finished work</p>
        <h2>The real dashboard, from raw data to an interpretable result.</h2>
        <p className="soccer-work-intro">These screenshots come directly from the finished application. They show how staff can move from the dataset overview to one player&apos;s workload, wellness, injury-report history and next-day readiness estimates.</p>
        <div className="soccer-visual-stack">
          <figure>
            <img src={withBasePath("/projects/soccer-health/dataset-overview.png")} alt="Soccer Health Monitor dataset overview with training-load and injury-report charts" />
            <figcaption><strong>Understanding the dataset.</strong> Two seasons of training load, wellness questionnaires and injury reports are summarised before any player-level interpretation is made.</figcaption>
          </figure>
          <figure>
            <img src={withBasePath("/projects/soccer-health/training-and-wellness.png")} alt="Daily training load and self-reported readiness charts" />
            <figcaption><strong>Workload and wellness timeline.</strong> Daily sRPE load, a seven-day trend and reported readiness are aligned on the same player timeline.</figcaption>
          </figure>
          <figure>
            <img src={withBasePath("/projects/soccer-health/wellness-and-injuries.png")} alt="Self-reported readiness chart and injury-report history" />
            <figcaption><strong>Wellness and report history.</strong> Readiness trends are placed next to dated injury reports so staff can investigate context without treating the dashboard as a diagnosis.</figcaption>
          </figure>
          <figure>
            <img src={withBasePath("/projects/soccer-health/prediction-results.png")} alt="Reported and predicted readiness values with error distribution" />
            <figcaption><strong>Model results for one player.</strong> Reported and predicted readiness, the error distribution and recent estimates make the model&apos;s performance visible rather than hiding it behind one score.</figcaption>
          </figure>
          <figure>
            <img src={withBasePath("/projects/soccer-health/method-and-limitations.png")} alt="Time-aware model evaluation and data pipeline" />
            <figcaption><strong>Method and limitations.</strong> A chronological train, validation and test split prevents future information from leaking into the model evaluation.</figcaption>
          </figure>
        </div>
      </section>
      <section className="case-callout"><span>Scope and ethics</span><p>The platform will present workload and wellness signals, not medical diagnoses. Injury reports are subjective and class-imbalanced, so injury prediction will remain an exploratory research question rather than a clinical claim.</p></section>
      <footer className="case-footer"><a href={withBasePath("/")}>← Back to all projects</a><span>Visual case study · anonymised data</span></footer>
    </main>
  );
}
