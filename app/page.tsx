import { withBasePath } from "./site-path";

const projects = [
  { kicker:"Football analytics · StatsBomb", title:"World Cup Finals: 2018 vs 2022", description:"A Python case study comparing two unforgettable finals through xG, shots, passing networks, tactical structures and the performances of Mbappé, Griezmann, Messi and Di María.", points:[], href:"/projects/argentina-2022", image:"/projects/argentina/france-2018-world-cup.png", alt:"France celebrating its 2018 World Cup victory" },
  { kicker:"Biomechanics · Team engineering project", title:"Paediatric prosthetic foot", description:"A passive 3D-printed PLA foot designed for a three-year-old child. The physical prototype resisted 800 N without failure and satisfied all five client requirements.", points:["Digital design and simulation","Physical prototype and testing","5 of 5 requirements validated"], href:"/projects/prosthetic-foot/design", image:"/projects/prosthetic/physical-prototype.png", alt:"Physical paediatric prosthetic foot prototype", visualClass:"prosthetic-card-visual" },
  { kicker:"Virtual reality · Healthcare", title:"Upper-limb rehabilitation in VR", description:"A Unity prototype for Meta Quest 2 that turns familiar object-placement tasks into an immersive upper-limb mobility exercise in a virtual kitchen and living room.", points:[], href:"/projects/vr-rehabilitation", image:"/projects/vr-rehabilitation/in-game-view.webp", alt:"Patient view inside the virtual rehabilitation kitchen" },
  { kicker:"Sports health · Machine learning", title:"Soccer Health Monitor", description:"A staff-facing prototype that turns training load and wellness reports into readable signals. The strongest model estimates next-day readiness with a mean absolute error of 0.76 points on the temporal test set.", points:["50 anonymised players","Two seasons of daily reports","Next-day readiness prediction"], href:"/projects/soccer-health", image:"/projects/soccer-health/dataset-overview.png", alt:"Soccer Health Monitor dataset overview with training-load and injury-report charts", visualClass:"soccer-dashboard-visual" },
  { kicker:"SQL · Relational database", title:"Airline SQL Database", description:"The database layer of an airline management application, covering flights, aircraft, airports, passengers, tickets, payments, maintenance and delays.", points:[], href:"/projects/airline-database", image:"/projects/airline-database/operations-control-room.webp", alt:"Illustration of an airline operations control room", button:"See the SQL →" },
];

export default function Home(){return <main>
  <nav className="topbar"><a className="brand" href="#top">Jérôme Desale</a><div className="nav-links"><a href="#work">Projects</a><a href="#about">About</a><a href="#contact">Contact</a></div></nav>
  <header className="simple-hero section-shell" id="top"><p className="kicker">Engineering · Health · Data</p><h1>Jérôme Desale</h1><p>Fifth-year engineering student specialising in e-Healthcare & Data Science, based near Paris, France.</p><a className="pink-button" href="#work">See my projects →</a></header>
  <section className="simple-work section-shell" id="work"><p className="kicker">Selected work</p>{projects.map((p,i)=><article className={`simple-project ${i%2?"reverse":""}`} key={p.title}>
    <div className="simple-project-copy"><span>{p.kicker}</span><h2>{p.title}</h2><p>{p.description}</p>{p.points.length > 0 && <ul>{p.points.map(x=><li key={x}>{x}</li>)}</ul>}<a className="pink-button" href={withBasePath(`${p.href}/`)}>{p.button || "View project →"}</a></div>
    <div className={`simple-project-image ${p.visualClass||""}`}><img src={withBasePath(p.image)} alt={p.alt}/></div>
  </article>)}</section>
<section id="about" className="about-section section-shell">
  <figure className="about-photo">
    <img
      src={withBasePath("/images/jerome-profile.png")}
      alt="Jérôme Desale"
    />
  </figure>

  <div className="about-content">
    <span className="about-label">About me</span>

    <h2>
      Fifth-year engineering student specialising in e-Healthcare & Data Science
    </h2>

    <p>
I’m Jérôme Desale, a fifth-year engineering student at EPF specialising in e-Healthcare and Data Science. I am particularly interested in using data and digital technologies to better understand health-related systems and develop practical solutions.
    </p>

    <p>
Through academic projects in prosthetic design, virtual-reality rehabilitation and machine learning for sports health, I have gained experience in combining engineering, software and data. I am currently developing my skills in machine learning and artificial intelligence, with the goal of contributing to useful and reliable healthcare technologies.
    </p>
    <a
    className="pink-button cv-button"
    href={withBasePath("/documents/jerome-desale-cv.pdf")}
    target="_blank"
    rel="noopener noreferrer"
    >
      My CV
    </a>
  </div>
</section>  <section className="simple-contact section-shell" id="contact">
  <p className="kicker">Contact</p>

  <h2>Get in touch.</h2>

  <p>
I am currently looking for a six-month final-year internship starting in February 2027. I am particularly interested in opportunities combining e-Healthcare, Data Science, AI, digital healthcare technologies and sport.

Whether you would like to discuss an internship opportunity, a potential project or a collaboration, feel free to get in touch. Email is the easiest way to contact me, and I will do my best to respond quickly.
  </p>

  <a
    className="pink-button"
    href="mailto:jerome.desale@epfedu.fr?subject=Internship opportunity"
  >
    Contact me
  </a>
</section>
  <footer><span>Jérôme Desale · 2026</span><span>Engineering × Health × Data</span></footer>
</main>}
