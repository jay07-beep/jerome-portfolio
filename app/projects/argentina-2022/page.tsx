import { withBasePath } from "../../site-path";

export default function ArgentinaCase(){return <main className="case-page">
  <nav className="case-nav"><a href={withBasePath("/")}>← Portfolio</a><span>StatsBomb case study</span></nav>
  <header className="case-hero world-cup-case-hero"><p className="kicker">Football analytics · World Cup finals</p><h1>Two finals. Two very different stories.</h1><p>I used Python and StatsBomb event data to compare France&apos;s efficient 4–2 victory in 2018 with the extraordinary 3–3 final between Argentina and France in 2022.</p></header>
  <div className="case-action-row"><a className="pink-button" href="https://colab.research.google.com/drive/1_HW7qwUw4qQToxOilq31e_INo4keW8zp?usp=sharing" target="_blank" rel="noreferrer">Open the Google Colab ↗</a><span>Full code, charts and explanations</span></div>

  <div className="world-cup-gallery">
    <figure><img src={withBasePath("/projects/argentina/france-2018-world-cup.png")} alt="France players celebrating with the 2018 World Cup trophy"/><figcaption><strong>2018:</strong> France - 2018 World Cup champions </figcaption></figure>
    <figure><img src={withBasePath("/projects/argentina/messi-2022-world-cup.png")} alt="Lionel Messi kissing the World Cup trophy after Argentina won in 2022"/><figcaption><strong>2022:</strong> Argentina - 2022 World Cup champions</figcaption></figure>
  </div>

  <section className="case-metrics"><div><strong>2</strong><span>World Cup finals</span></div><div><strong>53</strong><span>shots before the shoot-out</span></div><div><strong>12</strong><span>goals before the shoot-out</span></div><div><strong>7.61</strong><span>combined xG</span></div></section>
  <section className="football-visualisations">
  <div className="visualisations-heading">
    <span>DATA VISUALISATIONS</span>
    <h2>How the two finals unfolded</h2>

    <p>
      These visualisations were generated in Python from StatsBomb event
      data. They compare shot quality, goal locations and the evolution of
      expected goals throughout the two finals.
    </p>
  </div>

  <figure className="football-figure football-figure-large">
    <img
      src={withBasePath("/projects/argentina/shot-map-2022.png")}
      alt="Shot map comparing Argentina and France during the 2022 World Cup final"
    />

    <figcaption>
      Shot map of the 2022 final. Circle size represents the expected-goals
      value of each attempt, while stars indicate goals.
    </figcaption>
  </figure>

  <div className="xg-comparison-grid">
    <figure className="football-figure">
      <img
        src={withBasePath("/projects/argentina/cumulative-xg-2018.png")}
        alt="Cumulative expected goals for France and Croatia in the 2018 World Cup final"
      />

      <figcaption>
        <strong>2018:</strong> France converted its most important chances
        with remarkable efficiency despite Croatia producing more cumulative
        xG.
      </figcaption>
    </figure>

    <figure className="football-figure">
      <img
        src={withBasePath("/projects/argentina/cumulative-xg-2022.png")}
        alt="Cumulative expected goals for Argentina and France in the 2022 World Cup final"
      />

      <figcaption>
        <strong>2022:</strong> Argentina controlled most of the match before
        France dramatically recovered, particularly during the final minutes
        and extra time.
      </figcaption>
    </figure>
  </div>
  </section>

  <section className="case-section two-column"><div><p className="kicker">The project</p><h2>What does the score hide?</h2></div><div><p>The notebook goes beyond the final score to compare shot quality, xG, possession, passing networks, 15-minute attacking phases and individual player contributions.</p><p>The analysis uses StatsBomb&apos;s free event data for matches 8658 and 3869685. Shoot-out penalties are separated from open play so that the comparison remains readable.</p></div></section>

  <section className="case-section two-column"><div><p className="kicker">France · 2018</p><h2>Efficiency beat possession.</h2></div><div><ul className="case-list"><li>Croatia generated approximately 1.48 xG, compared with France&apos;s 1.10.</li><li>France still won 4–2 by converting its decisive chances with remarkable efficiency.</li><li>Mandžukić&apos;s own goal in the 18th minute increased the score but added no xG to France&apos;s total.</li><li>France&apos;s compact 4-4-2 defended narrow and attacked space quickly through Pogba, Griezmann and Mbappé.</li></ul></div></section>

  <section className="case-section two-column"><div><p className="kicker">Argentina · 2022</p><h2>Control, then chaos.</h2></div><div><ul className="case-list"><li>Argentina produced 20 shots and approximately 1.97 non-penalty xG; France produced 10 shots and 0.71.</li><li>France did not attempt a shot in the first half and changed Giroud and Dembélé before the break.</li><li>Di María&apos;s width and Messi&apos;s freedom helped Argentina dominate the opening phase.</li><li>Mbappé&apos;s hat-trick transformed a difficult collective performance into one of the most dramatic finals ever played.</li></ul></div></section>

  <section className="case-section two-column"><div><p className="kicker">Tactical change</p><h2>France changed its attacking structure.</h2></div><div className="tactical-text"><p>France moved from a compact 4-4-2 in 2018 to a 4-2-3-1 in 2022. The later structure gave Mbappé greater freedom on the left and placed Griezmann between midfield and attack, but Argentina successfully restricted those connections during the first half.</p></div></section>

  <section className="case-callout world-cup-callout"><span>Personal perspective</span><div><p>The 2022 final was the most spectacular international match I have ever watched. It was extraordinary, even though I would have preferred France to win.</p><a className="light-button" href="https://colab.research.google.com/drive/1_HW7qwUw4qQToxOilq31e_INo4keW8zp?usp=sharing" target="_blank" rel="noreferrer">Explore the complete analysis ↗</a></div></section>
  <footer className="case-footer"><a href={withBasePath("/")}>← All projects</a><a href="https://github.com/statsbomb/open-data" target="_blank" rel="noreferrer">StatsBomb open data ↗</a></footer>
</main>}
