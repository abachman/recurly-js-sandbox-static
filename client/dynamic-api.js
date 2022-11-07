if (!window.recurlyConfig) window.recurlyConfig = {};

const $ = (selector) => document.querySelector(selector);

$("#api_url").addEventListener("change", (evt) => {
  API_URL = evt.target.value.trim();

  try {
    // stub URL should have .js and .css
    const uri = new URL(API_URL);
    console.log({ API_URL, uri });

    const head = $("head");
    const scriptTag = document.createElement("script");
    head.appendChild(scriptTag);
    scriptTag.onload = () => {
      $("#api_url").disabled = true;
      $("#api_status").innerHTML = "script loaded";
    };
    scriptTag.src = uri.toString() + "/recurly.js";

    const styleTag = document.createElement("link");
    styleTag.type = "text/css";
    styleTag.rel = "stylesheet";
    styleTag.href = uri.toString() + "/recurly.css";
    head.appendChild(styleTag);

    $("#api_key").disabled = false;

    evt.target.classList.remove("error");

    localStorage.setItem("recurly_api_uri", API_URL);
  } catch (ex) {
    evt.target.classList.add("error");
    const msg = `failed to set URL: ${ex.message}`;
    console.error(msg);
    $("#api_status").innerHTML = msg;
  }
});

$("#api_key").addEventListener("change", (evt) => {
  const key = evt.target.value.trim();
  console.log("set public key to", key);
  window.recurlyConfig.publicKey = key;
  localStorage.setItem("recurly_api_key", key);
  $("#insert-button").disabled = false;
});

if (window.recurlyConfig.publicKey) {
  $("#api_key").style.display = "none";
}
