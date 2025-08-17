<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>منصة المحتوى</title>
<style>
  /* --- Reset & base --- */
  *{margin:0;padding:0;box-sizing:border-box;font-family:system-ui,"Noto Kufi Arabic",sans-serif}
  body{background:#f5f5f5;color:#111}

  /* --- Header --- */
  header{position:sticky;top:0;background:#0F7D7D;color:#fff;z-index:100}
  nav{display:flex;justify-content:center;gap:12px;padding:12px;flex-wrap:wrap}
  nav a{text-decoration:none;color:#fff;padding:8px 14px;border-radius:8px;transition:0.3s}
  nav a:hover, nav a.active{background:#fff;color:#0F7D7D}

  /* --- Container --- */
  .container{max-width:1200px;margin:auto;padding:18px}

  /* --- Grids --- */
  .grid{display:grid;gap:16px}
  .cards-articles{grid-template-columns:repeat(auto-fill,minmax(260px,1fr))}
  .cards-reels{grid-template-columns:repeat(auto-fill,minmax(160px,1fr))}
  .cards-programs{grid-template-columns:repeat(auto-fill,minmax(220px,1fr))}

  /* --- Card --- */
  .card{background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 2px 6px rgba(0,0,0,0.1);transition:0.3s}
  .card:hover{transform:translateY(-4px);box-shadow:0 4px 12px rgba(0,0,0,0.15)}
  .thumb{width:100%;height:0;padding-bottom:56.25%;background:#ddd;background-size:cover;background-position:center}
  .thumb.video{padding-bottom:177.77%;position:relative}
  .pad{padding:12px}
  .muted{color:#666;font-size:14px}

  /* --- Video overlay for play --- */
  .play-icon{
    position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
    font-size:36px;color:rgba(255,255,255,0.8);pointer-events:none;
  }
</style>
</head>
<body>

<header>
  <nav>
    <a href="#" class="active" data-tab="home">الرئيسية</a>
    <a href="#" data-tab="articles">مقالات</a>
    <a href="#" data-tab="reels">ريلز</a>
    <a href="#" data-tab="programs">البرامج</a>
    <a href="/admin/" target="_blank">لوحة التحكم</a>
  </nav>
</header>

<main class="container">

<!-- --- البرامج --- -->
<section id="programs-section">
  <h2>البرامج</h2>
  <div class="grid cards-programs" id="programs-container">
    <!-- محتوى البرامج يولد من CMS -->
  </div>
</section>

<!-- --- أحدث المقالات --- -->
<section id="articles-section">
  <h2>أحدث المقالات</h2>
  <div class="grid cards-articles" id="articles-container">
    <!-- محتوى المقالات يولد من CMS -->
  </div>
</section>

<!-- --- أحدث الريلز --- -->
<section id="reels-section">
  <h2>أحدث الريلز</h2>
  <div class="grid cards-reels" id="reels-container">
    <!-- محتوى الريلز يولد من CMS -->
  </div>
</section>

</main>

<script>
/* --- Mock data للعرض التوضيحي --- */
const programs = [
  {title:"إطار",desc:"برنامج إطار لتسهيل المحتوى",slug:"itar"},
  {title:"أرشيف",desc:"برنامج أرشيف للأرشفة",slug:"arsheef"}
];

const articles = [
  {title:"مقال 1",date:"2025-08-17",program:"itar",image:"https://via.placeholder.com/300x180",body:"ملخص المقال 1"},
  {title:"مقال 2",date:"2025-08-16",program:"arsheef",image:"https://via.placeholder.com/300x180",body:"ملخص المقال 2"}
];

const reels = [
  {title:"ريلز 1",date:"2025-08-17",program:"itar",cover:"https://via.placeholder.com/160x280",video:"https://www.w3schools.com/html/mov_bbb.mp4"},
  {title:"ريلز 2",date:"2025-08-16",program:"arsheef",cover:"https://via.placeholder.com/160x280",video:"https://www.w3schools.com/html/mov_bbb.mp4"}
];

/* --- توليد البطاقات ديناميكيًا --- */
function createPrograms(){ 
  const container = document.getElementById("programs-container");
  programs.forEach(p=>{
    const div = document.createElement("div");
    div.className="card pad";
    div.innerHTML=`<h3>${p.title}</h3><p class="muted">${p.desc}</p>`;
    container.appendChild(div);
  });
}

function createArticles(){ 
  const container = document.getElementById("articles-container");
  articles.forEach(a=>{
    const div = document.createElement("div");
    div.className="card";
    div.innerHTML=`
      <div class="thumb" style="background-image:url('${a.image}')"></div>
      <div class="pad">
        <h3>${a.title}</h3>
        <div class="muted">${a.date} — برنامج: ${a.program}</div>
        <p>${a.body}</p>
      </div>`;
    container.appendChild(div);
  });
}

function createReels(){ 
  const container = document.getElementById("reels-container");
  reels.forEach(r=>{
    const div = document.createElement("div");
    div.className="card";
    div.innerHTML=`
      <div class="thumb video" style="background-image:url('${r.cover}')">
        <span class="play-icon">&#9658;</span>
      </div>
      <div class="pad">
        <h3>${r.title}</h3>
        <div class="muted">${r.date} — برنامج: ${r.program}</div>
      </div>`;
    div.querySelector(".thumb").addEventListener("click",()=>{
      const video = document.createElement("video");
      video.src=r.video;
      video.controls=true;
      video.autoplay=true;
      video.style.width="100%";
      video.style.maxWidth="420px";
      div.innerHTML="";
      div.appendChild(video);
    });
    container.appendChild(div);
  });
}

/* --- Init --- */
createPrograms();
createArticles();
createReels();

/* --- تبويب الهيدر --- */
const tabs = document.querySelectorAll("nav a[data-tab]");
tabs.forEach(tab=>{
  tab.addEventListener("click",e=>{
    e.preventDefault();
    tabs.forEach(t=>t.classList.remove("active"));
    tab.classList.add("active");
    document.getElementById("programs-section").style.display = tab.dataset.tab=="programs"||tab.dataset.tab=="home" ? "block":"none";
    document.getElementById("articles-section").style.display = tab.dataset.tab=="articles"||tab.dataset.tab=="home" ? "block":"none";
    document.getElementById("reels-section").style.display = tab.dataset.tab=="reels"||tab.dataset.tab=="home" ? "block":"none";
  });
});
</script>

</body>
</html>
