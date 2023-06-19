#!/bin/sh

dirs="$@"
test -z "$dirs" && dirs="*"

mspertest=100

ok=0
succeeded=0
failed=0

(
  cd node_modules/glassfiber
  for a in glassfiber.min.js glassfiber.js
  do
    rm -f $a
    ln -s ../../$a $a
  done
)

for dir in testsuite/$dirs
do
  rm -f $dir/output.*
  result="$(node - <<HERE
async function main() {
const fs = require("fs");
var rxmlpublic = require("glassfiber");
var rxml = require("./glassfiber.min.js");
Object.assign(rxmlpublic, rxml);
var rxmlpathencode = require("glassfiber-pathencode");

var glassfibersrc = fs.readFileSync("$dir/template.glassfiber").toString();
var data = fs.readFileSync("$dir/data.json").toString();

var jssrcasync = rxml.glassfiber2js(glassfibersrc, 4);
var jssrc = rxml.glassfiber2js(glassfibersrc);

fs.writeFileSync("$dir/output.async.min.js", jssrcasync);
fs.writeFileSync("$dir/output.min.js", jssrc);

var macrofnasync = rxml.js2obj(jssrcasync);
var macrofn = rxml.js2obj(jssrc);

data = {"_":eval("("+data+")")};

if (macrofnasync)
  var resultasync = rxml.abstract2txt(await macrofnasync(data));
var result = rxml.abstract2txt(macrofn(data));

if (macrofnasync && resultasync !== result) {
  fs.writeFileSync("$dir/output.glassfiber", resultasync);
  console.error("Async mismatch");
  return;
}

var abstract;
var totaliters = 0.5;
var t1;
do {
 t1 = new Date();
 var iters = totaliters *= 2;
 do {
   //abstract = await macrofn(data);
   abstract = macrofn(data);
   //rxml.abstract2txt(abstract);
 } while (--iters);
 t2 = new Date();
} while (t2 - t1 < $mspertest)
var dt = (t2-t1)/totaliters;
console.log(Math.round(dt*1000)/1000);
fs.writeFileSync("$dir/output.glassfiber", rxml.abstract2txt(abstract));
}
main();
HERE
  )"
  js-beautify -s 2 $dir/output.async.min.js >$dir/output.async.js
  js-beautify -s 2 $dir/output.min.js >$dir/output.js
  if cmp -s $dir/target.glassfiber $dir/output.glassfiber
  then
    succeeded=$(($succeeded + 1))
    echo "Succeed: $dir	  $result"
  else
    failed=$(($failed + 1))
    echo "$result"
    echo "****************************************** Failed: $dir"
    ok=1
    ( cat <<\HERE
<html>
<head>
 <script src="glassfiber.js"></script>
 <script src="node_modules/glassfiber-dom/glassfiber-dom.js"></script>
 <script>
async function main() {
  var rxml = glassfiber;
  var data = {"_":
HERE
     cat $dir/data.json
     cat <<\HERE
  };
  var compfn = rxml.compile(`
HERE
     cat $dir/template.glassfiber
     cat <<\HERE
  `,4);
  var abstract = compfn(data);
  var html = rxml.abstract2txt(abstract);
  var dom = rxml.abstract2dom(abstract);
  console.log(html);
  console.log(compfn);
  console.log(dom);
}
 main();
 </script>
</head>
<body>
 Test me harder!
</body>
</html>
HERE
  ) >testsuite.html
  fi
done

echo "               Tests ===== succeeded: $succeeded  failed: $failed ====="

exit $ok
