#let template(title, body) = {
  set document(
    title: title,
    author: "Adam Martinez",
    date: none,
  )
  set heading(numbering: "1.")
  set text(lang: "en", region: "us")
  set footnote(numbering: "*")
  set cite(style: "alphanumeric")

  html.style(
    ```css
    body{
      color: #fff;
      background: #000;
      margin: 40px auto;
      max-width: 650px;
      line-height: 1.4;
      font-size: 18px;
      padding: 0 10px;}
    h1{line-height: 1.2; text-align: center}
    h2,h3{line-height: 1.2; border-bottom: 1px solid;}
    pre,blockquote,.signature{
      padding: 1em;
      background:#444;
    }
    blockquote,.signature{
      font-style: italic;
      margin: 2em 1em;}
    p,ul,ol { list-style-type: circle; text-align: justify;}
    a { color: #169; text-decoration: none; padding: 0.5em 0;}
    a:hover { text-decoration: underline;}
    .center {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 80%;
    }
    figcaption{ font-style: italic; font-size: 90%; text-align: center;}
    aside{ font-size: 50%;}
    code{ background-color: #444; font-size: 80%;}
    .ref li{ margin: auto auto 1em; text-align: start;}
    .header{
      margin: 1em 0;
      display: block;
      width: 100%;
    }
    .horizontal { text-align: center; padding: 10px 40px;}
    .horizontal li{display: inline-block; margin: 0 0.5em;}
    a[href^="mailto"]::after {content:' 📧';}
    a[href^="gemini"]::after {content:' 🚀';}```
      .text
      .trim(at: start),
  )

  body
}

#let css-credits = [CSS blatantly copied from #link(
    "https://offpunk.net/",
  )[Offpunk]'s site with some modifications.]
