
"use strict";

const STORAGE_KEY = "week9HiringToolkit.v1";

const COMPETENCIES = [
  {
    id: "communication",
    name: "Kommunikatsioon",
    description: "Selge eneseväljendus, kuulamine ja info edastamine."
  },
  {
    id: "problemSolving",
    name: "Probleemilahendus",
    description: "Analüütiline mõtlemine ja lahenduste põhjendamine."
  },
  {
    id: "teamwork",
    name: "Meeskonnatöö",
    description: "Koostöö, tagasiside ja ühiste eesmärkide saavutamine."
  },
  {
    id: "adaptability",
    name: "Kohanemisvõime ja õppimine",
    description: "Õppimisvalmidus, kohanemine ja vastutuse võtmine."
  }
];

const $ = (id) => document.getElementById(id);

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

function renderCompetencies(data) {
  const container = $("competencyFields");
  container.replaceChildren();

  COMPETENCIES.forEach((competency) => {
    const saved = data.ratings[competency.id] || {};
    const starData = data.star[competency.id] || {};
    const initialScore = saved.score ?? starData.score ?? "";

    const section = document.createElement("section");
    section.className = "competency";

    const heading = document.createElement("h3");
    heading.textContent = competency.name;

    const description = document.createElement("p");
    description.textContent = competency.description;

    const label = document.createElement("div");
    label.className = "field-label";
    label.textContent = "Hinne (1–5)";

    const group = document.createElement("div");
    group.className = "rating-group";

    for (let n = 1; n <= 5; n++) {
      const optionLabel = document.createElement("label");
      optionLabel.className = "rating-option";

      const radio = document.createElement("input");
      radio.type = "radio";
      radio.name = "rating-" + competency.id;
      radio.value = String(n);
      radio.checked = Number(initialScore) === n;

      radio.addEventListener("change", () => {
        const current = readData();
        current.ratings[competency.id] = {
          ...(current.ratings[competency.id] || {}),
          score: n
        };
        writeData(current);
        updateSummary();
      });

      optionLabel.append(radio, document.createTextNode(String(n)));
      group.append(optionLabel);
    }

    const evidenceLabel = document.createElement("label");
    evidenceLabel.htmlFor = "evidence-" + competency.id;
    evidenceLabel.textContent = "Tõendid ja põhjendus";

    const evidence = document.createElement("textarea");
    evidence.id = "evidence-" + competency.id;
    evidence.placeholder = "Milline vastus või näide hinnet toetab?";
    evidence.value = saved.evidence || starData.evidence || "";

    evidence.addEventListener("change", () => {
      const current = readData();
      current.ratings[competency.id] = {
        ...(current.ratings[competency.id] || {}),
        evidence: evidence.value
      };
      writeData(current);
    });

    section.append(
      heading, description, label, group, evidenceLabel, evidence
    );

    container.append(section);
  });
}

function readForm() {
  const data = readData();

  data.candidate.name = $("candidateName").value.trim();
  data.candidate.position = $("position").value.trim();
  data.candidate.evaluator = $("evaluator").value.trim();
  data.candidate.interviewDate = $("interviewDate").value;
  data.recommendation = $("recommendation").value;
  data.overallNotes = $("overallNotes").value.trim();

  COMPETENCIES.forEach(({ id }) => {
    const selected = document.querySelector(
      `input[name="rating-${id}"]:checked`
    );
    const evidence = $("evidence-" + id).value;

    data.ratings[id] = {
      ...(data.ratings[id] || {}),
      score: selected ? Number(selected.value) : null,
      evidence
    };
  });

  return data;
}

function updateSummary() {
  const data = readForm();

  const scores = COMPETENCIES
    .map(({ id }) => data.ratings[id]?.score)
    .filter((score) =>
      Number.isInteger(score) && score >= 1 && score <= 5
    );

  const count = scores.length;
  const average = count
    ? scores.reduce((sum, score) => sum + score, 0) / count
    : 0;

  $("averageScore").textContent = count
    ? average.toFixed(2) + " / 5"
    : "— / 5";

  $("progressBar").style.width = (average / 5 * 100) + "%";
  $("scoreCount").textContent = count + " / " +
    COMPETENCIES.length + " hinnatud";

  $("scoreStatus").textContent =
    count === COMPETENCIES.length
      ? "Kõik kompetentsid on hinnatud."
      : "Täida ülejäänud hinded. Keskmine põhineb ainult antud hinnetel.";

  return { count, average };
}

function fillForm(data) {
  $("candidateName").value = data.candidate.name || "";
  $("position").value = data.candidate.position || "";
  $("evaluator").value = data.candidate.evaluator || "";
  $("interviewDate").value = data.candidate.interviewDate || "";
  $("recommendation").value = data.recommendation || "";
  $("overallNotes").value = data.overallNotes || "";

  renderCompetencies(data);
  updateSummary();
}

function save() {
  const form = $("scorecardForm");

  if (!form.reportValidity()) return;

  const data = readForm();

  if (writeData(data)) {
    $("saveStatus").textContent = "Hindamine salvestatud.";
  }
}

function exportJSON() {
  const data = readForm();
  const result = updateSummary();

  data.summary = {
    ratedCompetencies: result.count,
    totalCompetencies: COMPETENCIES.length,
    average: result.count === COMPETENCIES.length
      ? Number(result.average.toFixed(2))
      : null
  };

  const blob = new Blob(
    [JSON.stringify(data, null, 2)],
    { type: "application/json;charset=utf-8" }
  );

  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = "hiring-scorecard.json";
  link.click();
  URL.revokeObjectURL(url);

  writeData(data);
}

function init() {
  const data = readData();
  fillForm(data);

  [
    "candidateName",
    "position",
    "evaluator",
    "interviewDate",
    "recommendation",
    "overallNotes"
  ].forEach((id) => {
    $(id).addEventListener("change", () => {
      const current = readForm();
      writeData(current);
      updateSummary();
    });
  });

  $("saveButton").addEventListener("click", save);
  $("exportButton").addEventListener("click", exportJSON);
  $("printButton").addEventListener("click", () => window.print());

  $("scorecardForm").addEventListener("submit", (event) => {
    event.preventDefault();
    save();
  });

  updateSummary();
}

init();

