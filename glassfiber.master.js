   /** @license
   ** Glassfiber v6: Coroutines implemented using Promises
  ** Copyright (c) 2023-2023 by Stephen R. van den Berg <srb@cuci.nl>
 ** License: ISC OR GPL-3.0
** Sponsored by: Cubic Circle, The Netherlands
*/

/** @define {number} */ var DEBUG = 1;
/** @define {number} */ var ALERTS = 0;
/** @define {number} */ var RUNTIMEDEBUG = 0;
/** @define {number} */ var MEASUREMENT = 0;
/** @define {number} */ var ASSERT = 1;
/** @define {number} */ var VERBOSE = 0;

// Cut BEGIN delete
(() =>
{ "use strict";
// Cut END delete

  // Cut BEGIN for externs
  // Cut BEGIN for prepend
  // Cut END for prepend
  // Cut END for externs
  // Cut BEGIN for prepend
  // Cut END for prepend

  const O = Object;

  const /** !Object */ g =
  { "yield": sched_yield,
    "sleep": sleep,
    "spawn": spawn
  };

  // Priorities 0, 1, 2, 3 available

  const runqueue = [[],[],[],[]];

  function /** * */ runnext(/** * */ spawnpromise)
  { var /** number */ prio;
    for (prio = 0; prio < runqueue.length; prio++)
    { let /** function():void */ resolvethread = runqueue[prio].shift();
      if (resolvethread)
      { // Tight interpreter scheduling
        // resolvethread();
	// Loose interpreter scheduling
        setTimeout(resolvethread);
        break;
      }
    }
    // Idle
    return spawnpromise;
  }

  function /** !Promise */ sched_yield(/** number= */ priority)
  { var /** !Promise */ newpromise
     = new Promise((resolve) => runqueue[priority || 0].push(resolve));
    runnext();
    return newpromise;
  }

  function /** !Promise */ sleep(/** number */ ms)
  { var /** !Promise */ newpromise
     = new Promise((resolve) => setTimeout(() => resolve(), ms));
    runnext();
    return newpromise;
  }

  function /** !Promise */ spawn(/** !Promise */ promise)
  { return promise.then(runnext);     // What do we do with rejects?
  }

  if (typeof define == "function" && define["amd"])
    define("glassfiber", g);
  else if (typeof exports == "object")
    O.assign(/** @type{!Object} */(exports), g);
  else
    window["Glassfiber"] = g;

// Cut BEGIN delete
}).call(this);
// Cut BEGIN end
