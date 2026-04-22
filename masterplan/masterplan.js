const graphCanvas = document.querySelector(".graph-bg");

if (graphCanvas) {
  const graphContext = graphCanvas.getContext("2d");
  const pointer = {
    x: window.innerWidth * 0.72,
    y: window.innerHeight * 0.34,
    active: false,
  };
  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let graphWidth = 0;
  let graphHeight = 0;
  let graphRatio = 1;
  let nodes = [];

  function resetGraph() {
    graphRatio = Math.min(window.devicePixelRatio || 1, 2);
    graphWidth = window.innerWidth;
    graphHeight = window.innerHeight;
    graphCanvas.width = Math.floor(graphWidth * graphRatio);
    graphCanvas.height = Math.floor(graphHeight * graphRatio);
    graphCanvas.style.width = `${graphWidth}px`;
    graphCanvas.style.height = `${graphHeight}px`;
    graphContext.setTransform(graphRatio, 0, 0, graphRatio, 0, 0);

    const nodeCount = Math.round(Math.min(150, Math.max(70, (graphWidth * graphHeight) / 14500)));

    nodes = Array.from({ length: nodeCount }, () => {
      const speed = reducedMotion ? 0 : 0.14 + Math.random() * 0.28;
      const angle = Math.random() * Math.PI * 2;

      return {
        x: Math.random() * graphWidth,
        y: Math.random() * graphHeight,
        vx: Math.cos(angle) * speed,
        vy: Math.sin(angle) * speed,
        r: 0.9 + Math.random() * 1.7,
        tint: Math.random() > 0.5 ? "warm" : "cool",
      };
    });
  }

  function pointerGlow(x, y) {
    const dx = x - pointer.x;
    const dy = y - pointer.y;
    const distance = Math.sqrt(dx * dx + dy * dy);
    const radius = Math.min(420, Math.max(260, graphWidth * 0.26));
    const glow = Math.max(0, 1 - distance / radius);
    return pointer.active ? glow * glow : glow * glow * 0.28;
  }

  function drawGraph() {
    graphContext.clearRect(0, 0, graphWidth, graphHeight);
    graphContext.fillStyle = "#090b08";
    graphContext.fillRect(0, 0, graphWidth, graphHeight);

    const maxDistance = Math.min(210, Math.max(130, graphWidth / 7));

    for (let index = 0; index < nodes.length; index += 1) {
      const node = nodes[index];

      if (!reducedMotion) {
        node.x += node.vx;
        node.y += node.vy;

        if (node.x < -12) node.x = graphWidth + 12;
        if (node.x > graphWidth + 12) node.x = -12;
        if (node.y < -12) node.y = graphHeight + 12;
        if (node.y > graphHeight + 12) node.y = -12;
      }

      for (let nextIndex = index + 1; nextIndex < nodes.length; nextIndex += 1) {
        const other = nodes[nextIndex];
        const dx = node.x - other.x;
        const dy = node.y - other.y;
        const distance = Math.sqrt(dx * dx + dy * dy);

        if (distance > maxDistance) {
          continue;
        }

        const midX = (node.x + other.x) / 2;
        const midY = (node.y + other.y) / 2;
        const localGlow = pointerGlow(midX, midY);
        const alpha = (1 - distance / maxDistance) * (0.14 + localGlow * 1.05);

        graphContext.strokeStyle = `rgba(215, 213, 199, ${alpha})`;
        graphContext.lineWidth = 0.65 + localGlow * 1.7;
        graphContext.beginPath();
        graphContext.moveTo(node.x, node.y);
        graphContext.lineTo(other.x, other.y);
        graphContext.stroke();
      }
    }

    for (const node of nodes) {
      const localGlow = pointerGlow(node.x, node.y);
      const alpha = 0.22 + localGlow * 0.9;
      const color = node.tint === "warm" ? "214, 169, 75" : "130, 168, 104";

      graphContext.fillStyle = `rgba(${color}, ${alpha})`;
      graphContext.beginPath();
      graphContext.arc(node.x, node.y, node.r + localGlow * 2.7, 0, Math.PI * 2);
      graphContext.fill();

      if (localGlow > 0.18) {
        graphContext.fillStyle = `rgba(243, 239, 217, ${localGlow * 0.72})`;
        graphContext.beginPath();
        graphContext.arc(node.x, node.y, node.r * 0.54, 0, Math.PI * 2);
        graphContext.fill();
      }
    }

    requestAnimationFrame(drawGraph);
  }

  window.addEventListener(
    "pointermove",
    (event) => {
      pointer.x = event.clientX;
      pointer.y = event.clientY;
      pointer.active = true;
    },
    { passive: true },
  );

  window.addEventListener("pointerleave", () => {
    pointer.active = false;
  });

  window.addEventListener("resize", resetGraph);

  resetGraph();
  requestAnimationFrame(drawGraph);
}
