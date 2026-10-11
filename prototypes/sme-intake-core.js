(function (global) {
  "use strict";

  function normalizeText(value) {
    return String(value ?? "")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/\s+/g, " ")
      .trim();
  }

  function hasAny(text, terms) {
    return terms.some((term) => text.includes(term));
  }

  function result(category, detail) {
    return { category, safe: true, detail };
  }

  function classifyRequest(input) {
    const text = normalizeText(input);
    const words = text ? text.split(" ").filter(Boolean) : [];

    if (!text || words.length < 3) {
      return result("clarify", "Pedir aclaración; no inferir hechos a partir de una solicitud vacía o demasiado breve.");
    }

    if (hasAny(text, ["reservar una mesa", "restaurante", "billete de avion", "vuelo", "receta medica"])) {
      return result("out_of_scope", "La petición está fuera del alcance de esta demo; explicar límites y derivar a una persona.");
    }

    const urgent = hasAny(text, ["urgente", "una hora", "ahora mismo", "ha dejado de funcionar", "equipo parado", "maquina parada"]);
    const domainContext = hasAny(text, ["equipo", "maquina", "averia", "reparacion", "revision", "servicio", "cita", "fallo", "problema"]);
    const quote = hasAny(text, ["presupuesto", "precio", "coste", "cuanto cuesta"]);
    const budgetConstraint = hasAny(text, ["presupuesto maximo", "maximo de", "tope", "limite de"]);
    const info = hasAny(text, ["horario", "direccion", "donde estais", "ubicacion"]);
    const problem = hasAny(text, ["averia", "roto", "rota", "fallo", "falla", "problema"]);

    if (urgent && (!domainContext || quote)) {
      return result("human_review", "Hay una señal de urgencia insuficiente o mezclada con otra intención; requiere revisión humana.");
    }
    if (urgent && domainContext) {
      return result("urgent", "Revisión humana inmediata; comprobar disponibilidad sin prometer una solución.");
    }
    if (quote && budgetConstraint && problem) {
      return result("human_review", "La solicitud combina avería y límite económico; revisar antes de responder o presupuestar.");
    }
    if (quote) {
      return result("quote", "Pedir los datos necesarios antes de preparar un presupuesto; no inventar alcance ni precio.");
    }
    if (info) {
      return result("info", "Solo facilitar horario, dirección o ubicación cuando estén verificados por el negocio.");
    }
    if (problem && words.length < 6) {
      return result("clarify", "La descripción del problema es insuficiente; pedir una aclaración concreta.");
    }

    return result("human_review", "No hay una regla suficientemente fiable; derivar a revisión humana en vez de adivinar.");
  }

  function draftFor(category) {
    const drafts = {
      urgent: "Hola, gracias por avisarnos. Vamos a comprobar la disponibilidad y te confirmaremos cuanto antes si podemos atenderlo. Este borrador no se ha enviado.",
      quote: "Hola, gracias por contactar. Para preparar un presupuesto orientativo necesitamos confirmar el equipo y el servicio requerido. Revisaremos la información antes de responder. Este borrador no se ha enviado.",
      info: "Hola, gracias por escribirnos. Facilitaremos horario y ubicación únicamente cuando estén verificados por el negocio. Este borrador no se ha enviado.",
      clarify: "Hola. Necesitamos algún detalle adicional para entender correctamente la solicitud antes de responder. Este borrador no se ha enviado.",
      human_review: "La solicitud necesita revisión humana antes de preparar una respuesta. No se ha enviado ningún mensaje.",
      out_of_scope: "Esta solicitud queda fuera del alcance de la demo y debe revisarla una persona. No se ha enviado ningún mensaje."
    };
    return drafts[category] || drafts.human_review;
  }

  global.NexiaSME = Object.freeze({
    classifyRequest,
    draftFor,
    normalizeText
  });
})(globalThis);
