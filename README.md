<h1>Glassfiber</h1>

[![NPM version](http://img.shields.io/npm/v/glassfiber.svg?style=flat)](https://npmjs.org/package/glassfiber)
[![Downloads](https://img.shields.io/npm/dm/glassfiber.svg?style=flat)](https://npmjs.org/package/glassfiber)
[![Rate on Openbase](https://badges.openbase.io/js/rating/glassfiber.svg)](https://openbase.io/js/glassfiber?utm_source=embedded&utm_medium=badge&utm_campaign=rate-badge)
![Lib Size](https://img.badgesize.io/https:/unpkg.com/glassfiber/glassfiber.min.js?compression=gzip)
[![Code Quality](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/BuGlessRB/glassfiber)

Glassfiber is an intuitive Javascript co-routine library implemented
using Promises.

## Requirements

It runs inside any webbrowser or NodeJS environment supporting at least
ECMAScript ES2018.

Minified and gzip-compressed, it is less than 1 KB of code.

It has zero dependencies on other modules.

## Basic usage

Example:
```js
var Glassfiber = require("glassfiber.min.js");

async function threadA(a, b) {
  console.log("A starting");
  await Glassfiber.yield();
  console.log(a);
  await Glassfiber.sleep(1000);
  await Glassfiber.yield();
  console.log(b);
  await Glassfiber.yield();
  console.log("A done");
}

async function threadB(a, b, c) {
  console.log("B starting");
  await Glassfiber.yield();
  console.log(a);
  await Glassfiber.yield();
  await Glassfiber.sleep(500);
  console.log(b);
  await Glassfiber.yield();
  console.log(c);
  await Glassfiber.yield();
  console.log("B done");
}

async function threadC(a) {
  console.log("C starting");
  await Glassfiber.yield();
  await Glassfiber.sleep(250);
  console.log(a);
  await Glassfiber.yield();
  console.log("C done");
}

async function main() {
  var p1 = Glassfiber.spawn( threadA(12, 13) );
  var p2 = Glassfiber.spawn( threadB(14, 15, 16) );
  var p3 = Glassfiber.spawn( threadC(17) );
  await Promise.all([p1, p2, p3]);
}

main();
````

## Reference documentation

### API

Specified parameters:
- `priority` is an optional priority<br />
  Can be 0, 1, 2 or 3 (defaults to 0 if omitted).
- `ms` delay in milliseconds<br />

Exposed API-list (in NodeJS and the browser):
- `Glassfiber.spawn(promise)`<br />
  Spawn a new co-routine.  Passes through the promise.
- `Glassfiber.yield(priority?)`<br />
  Give other coroutines a chance to run, specifying our own priority (lower
  numbers are more important).  Returns a Promise.
- `Glassfiber.sleep(ms)`<br />
  Sleeps for this many milliseconds, returns a Promise.

## References

- [js-coroutines](https://github.com/miketalbot/js-coroutines).

Card-carrying member of the `zerodeps` movement.
