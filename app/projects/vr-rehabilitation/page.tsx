import { withBasePath } from "../../site-path";

const journey = [
  {
    number: "01",
    title: "Understand the exercise",
    text: "The player starts in a dedicated onboarding scene. Sequential coaching cards explain the task before loading the main environment.",
  },
  {
    number: "02",
    title: "Find the highlighted object",
    text: "The next object is shown in cyan. Only its matching placement zone is active, keeping the instructions simple and progressive.",
  },
  {
    number: "03",
    title: "Reach, grasp and place",
    text: "Objects are distributed across a kitchen and living room at different positions and heights to encourage everyday upper-limb movements.",
  },
  {
    number: "04",
    title: "Receive immediate feedback",
    text: "A correct placement adds points and advances the sequence. An incorrect placement triggers an error sound and returns the object for another attempt.",
  },
  {
    number: "05",
    title: "Review the session",
    text: "The final object stops the timer, launches a firework effect and opens a spatial panel with the score, elapsed time and a restart button.",
  },
];

const systems = [
  ["Sequential task manager", "Controls the ordered object-placement exercise, target highlighting, active sockets and success or error logic."],
  ["ScoreManager", "Updates the score and connects the session results to the end-of-game interface."],
  ["TimerManager", "Tracks the session in MM:SS, stops at completion and exposes the elapsed time to the final panel."],
  ["CoachingCardVR", "Displays tutorial cards one by one and moves the player from onboarding into the exercise scene."],
  ["PanelFin", "Positions the result panel in front of the player, displays the final metrics and reloads the experience on request."],
];

export default function VrRehabilitationCaseStudy() {
  return (
    <main className="case-page vr-case-page">
      <nav className="case-nav">
        <a href={withBasePath("/")}>← Portfolio</a>
        <span>Unity · Meta Quest 2</span>
      </nav>

      <header className="case-hero vr-case-hero">
        <p className="kicker">Virtual reality · Motor rehabilitation</p>
        <h1>Everyday movement, rebuilt in VR</h1>
        <p>
           My project partner and I developed an immersive upper-limb rehabilitation exercise for Meta Quest 2, transforming familiar object-placement tasks into engaging mobility activities.
        </p>
      </header>

      <figure className="case-figure vr-hero-figure">
        <img src={withBasePath("/projects/vr-rehabilitation/in-game-view.webp")} alt="First-person view of the virtual kitchen and living room with a timer and score" />
        <figcaption>The exercise from the player&apos;s point of view: a familiar home environment, a visible timer and a simple score.</figcaption>
      </figure>

      <section className="case-metrics">
        <div><strong>Meta Quest 2</strong><span>target headset</span></div>
        <div><strong>2 scenes</strong><span>onboarding and exercise</span></div>
        <div><strong>5 steps</strong><span>from tutorial to final results</span></div>
        <div><strong>5 C# scripts</strong><span>interaction, score and feedback systems</span></div>
      </section>

      <section className="case-section two-column">
        <div>
          <p className="kicker">The project idea</p>
          <h2>Make rehabilitation movements feel concrete.</h2>
        </div>
        <div className="vr-intro-text">
          <p>The prototype turns reaching, grasping and placing into a sequence of ordinary household actions. Plates, a chessboard, a sculpture, a vase, a cup and a teapot are positioned at different heights and locations across a virtual kitchen and living room.</p>
          <p>The intended use is a playful mobility exercise that could help a healthcare professional observe how a patient performs upper-limb movements in several situations.</p>
        </div>
      </section>

      <figure className="case-figure vr-room-figure">
        <img src={withBasePath("/projects/vr-rehabilitation/room-overview.webp")} alt="Top view of the Unity rehabilitation environment combining a kitchen and living room" />
        <figcaption>The complete Unity environment viewed from above. Objects and placement zones are distributed throughout the room.</figcaption>
      </figure>

      <section className="case-section">
        <p className="kicker">A concrete session</p>
        <h2>From tutorial to final score.</h2>
        <div className="vr-journey">
          {journey.map((step) => (
            <article key={step.number}>
              <span>{step.number}</span>
              <h3>{step.title}</h3>
              <p>{step.text}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="visual-pair vr-visual-pair">
        <figure>
          <img className="vr-tutorial-image" src={withBasePath("/projects/vr-rehabilitation/tutorial.webp")} alt="Virtual coaching card welcoming the player to the rehabilitation exercise" />
          <figcaption> The player scrolls through a series of spatial panels that explain all the rules before starting the exercise.</figcaption>
        </figure>
        <figure>
          <img className="vr-plate-image" src={withBasePath("/projects/vr-rehabilitation/target-highlight.webp")} alt="Two virtual plates with the target plate highlighted in cyan" />
          <figcaption>The expected object is highlighted in cyan to make the next action immediately understandable.</figcaption>
        </figure>
      </section>

      <section className="case-section two-column">
        <div>
          <p className="kicker">Unity implementation</p>
          <h2>Five systems working as one exercise.</h2>
        </div>
        <div className="vr-system-list">
          {systems.map(([title, text]) => (
            <article key={title}>
              <h3>{title}</h3>
              <p>{text}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="case-section two-column">
        <div>
          <p className="kicker">Iteration after evaluation</p>
          <h2>Feedback became visible product changes.</h2>
        </div>
        <div>
          <p>After the first evaluation, the team added ambient sound, an error sound for incorrect placement, a session timer and a firework sequence at completion. These additions make the task easier to follow and give both the player and practitioner clearer feedback.</p>
          <ul className="case-list">
            <li>Immediate audio feedback for incorrect placement.</li>
            <li>Timer and score for a simple, repeatable session summary.</li>
            <li>Celebratory visual and audio feedback at completion.</li>
            <li>Restart action directly from the final spatial panel.</li>
          </ul>
          <p className="method-note">Remaining ideas documented in the report include changing particle colour after a correct placement and randomising the object sequence between sessions.</p>
        </div>
      </section>

      <section className="visual-pair vr-visual-pair vr-final-visuals">
        <figure>
          <img src={withBasePath("/projects/vr-rehabilitation/completion-panel.webp")} alt="Final virtual panel showing a score, elapsed time, restart button and fireworks" />
          <figcaption>The end panel faces the player and combines score, elapsed time, restart control and celebratory feedback.</figcaption>
        </figure>
        <figure>
          <img src={withBasePath("/projects/vr-rehabilitation/deposit-particles.webp")} alt="Particles marking a virtual object placement zone above the kitchen sink" />
          <figcaption>Particles identify an active placement zone inside the virtual room.</figcaption>
        </figure>
      </section>

      <section className="case-callout">
        <span>What I learned</span>
        <p>I particularly enjoyed this project because it combined virtual reality, healthcare and user-centred design. It also taught me that building a useful VR experience is not only about the 3D environment: guidance, error recovery, feedback and a readable end state are what turn separate interactions into a coherent user journey.</p>
      </section>

      <footer className="case-footer">
        <a href={withBasePath("/")}>← Back to all projects</a>
        <span>Team project · EPF Engineering School</span>
      </footer>
    </main>
  );
}
