
"use strict";

const STORAGE_KEY = "week9HiringToolkit.v1";

const COMPETENCIES = [
  {
    id: "communication",
    name: "Kommunikatsioon",
    question: "Kirjelda olukorda, kus pidid keerulist infot selgelt edastama või lahendama arusaamatuse."
  },
  {
    id: "problemSolving",
    name: "Probleemilahendus",
    question: "Too näide keerulisest probleemist, mille lahendasid. Kuidas analüüsisid olukorda ja valisid lahenduse?"
  },
  {
    id: "teamwork",
    name: "Meeskonnatöö",
    question: "Kirjelda olukorda, kus pidid tegema koostööd erinevate inimestega või lahendama meeskonnasisese erimeelsuse."
  },
  {
    id: "adaptability",
    name: "Kohanemisvõime ja õppimine",
    question: "Too näide olukorrast, kus pidid kiiresti õppima midagi uut või kohanema ootamatu muutusega."
  }
];

const $ = (id) => document.getElementById(id);

let activeCompetency = COMPETENCIES[0].id;

const STAR_FIELDS = [
  "situation",
  "task",
  "action",
  "result",
  "followUp",
  "customQuestion",
  "evidence"
];

function emptyData() {
  return {
    candidate: {
      name: "",
      position: "",
      evaluator: "",
      interviewDate: ""
    },
    ratings: {},
    recommendation: "",
    overallNotes: "",
    star: {},
    updatedAt: null
  };
}

function readData() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return emptyData();

    const parsed = JSON.parse(raw);
    const data = { ...emptyData(), ...parsed };

    data.candidate = {
      ...emptyData().candidate,
      ...(parsed.candidate || {})
    };
    data.ratings = parsed.ratings || {};
    data.star = parsed.star || {};

    return data;
  } catch (error) {
    console.error("Andmete lugemine ebaõnnestus:", error);
    return emptyData();
  }
}

function writeData(data) {
  try {
    data.updatedAt = new Date().toISOString();
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    $("saveStatus").textContent = "Salvestatud selles brauseris.";
    return true;
  } catch (error) {
    console.error("Salvestamine ebaõnnestus:", error);
    $("saveStatus").textContent =
      "Salvestamine ebaõnnestus. Ekspordi andmed JSON-failina.";
    return false;
  }
}

function renderTabs() {
  const container = $("competencyTabs");
  container.replaceChildren();

  COMPETENCIES.forEach((competency) => {
    const button = document.createElement("button");
    button.type = "button";
    button.textContent = competency.name;
    button.setAttribute(
      "aria-pressed",
      String(competency.id === activeCompetency)
    );

    button.addEventListener("click", () => {
      saveActive(false);
      activeCompetency = competency.id;
      renderTabs();
      loadActive();
    });

    container.append(button);
  });
}

function currentFields() {
  const result = {};

  STAR_FIELDS.forEach((id) => {
    result[id] = $(id).value;
  });

  result.score = $("starScore").value
    ? Number($("starScore").value)
    : null;

  result.checklist = {
    specific: $("checkSpecific").checked,
    ownership: $("checkOwnership").checked,
    result: $("checkResult").checked,
    evidence: $("checkEvidence").checked
  };

  return result;
}

function saveActive(showMessage = true) {
  const data = readData();

  data.candidate.name = $("candidateName").value.trim();
  data.candidate.position = $("position").value.trim();
  data.candidate.evaluator = $("interviewer").value.trim();

  const fields = currentFields();

  data.star[activeCompetency] = {
    ...fields,
    savedAt: new Date().toISOString()
  };

  // Kui STAR-vormis on hinne antud, kasuta seda Scorecardi
  // esialgse hindena. Scorecardis saab hinnet hiljem muuta.
  if (fields.score !== null) {
    data.ratings[activeCompetency] = {
      ...(data.ratings[activeCompetency] || {}),
      score: fields.score,
      evidence: fields.evidence
    };
  }

  const saved = writeData(data);

  if (saved && showMessage) {
    $("saveStatus").textContent =
      "STAR-vastus ja hindamistõendid on salvestatud.";
  }

  return saved;
}

function loadActive() {
  const data = readData();
  const competency = COMPETENCIES.find(
    (item) => item.id === activeCompetency
  );

  const saved = data.star[activeCompetency] || {};

  $("questionPrompt").textContent = competency.question;

  STAR_FIELDS.forEach((id) => {
    $(id).value = saved[id] || "";
  });

  $("starScore").value = saved.score
    ? String(saved.score)
    : (data.ratings[activeCompetency]?.score
        ? String(data.ratings[activeCompetency].score)
        : "");

  const checks = saved.checklist || {};

  $("checkSpecific").checked = Boolean(checks.specific);
  $("checkOwnership").checked = Boolean(checks.ownership);
  $("checkResult").checked = Boolean(checks.result);
  $("checkEvidence").checked = Boolean(checks.evidence);

  renderTabs();
}

function exportJSON() {
  saveActive(false);
  const data = readData();

  const blob = new Blob(
    [JSON.stringify(data, null, 2)],
    { type: "application/json;charset=utf-8" }
  );

  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = "star-interview.json";
  link.click();
  URL.revokeObjectURL(url);
}

function init() {
  const data = readData();

  $("candidateName").value = data.candidate.name || "";
  $("position").value = data.candidate.position || "";
  $("interviewer").value = data.candidate.evaluator || "";

  renderTabs();
  loadActive();

  $("saveButton").addEventListener("click", () => {
    saveActive(true);
  });

  $("exportButton").addEventListener("click", exportJSON);
  $("printButton").addEventListener("click", () => window.print());

  // Salvesta väljade muutmisel. Nii ei lähe märkmed kaduma,
  // kui intervjueerija vahetab kompetentsi vahelehte.
  [
    ...STAR_FIELDS,
    "starScore",
    "checkSpecific",
    "checkOwnership",
    "checkResult",
    "checkEvidence"
  ].forEach((id) => {
    $(id).addEventListener("change", () => saveActive(false));
  });

  ["candidateName", "position", "interviewer"].forEach((id) => {
    $(id).addEventListener("change", () => saveActive(false));
  });

  window.addEventListener("beforeunload", () => saveActive(false));
}

init();


