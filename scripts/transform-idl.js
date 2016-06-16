#!/usr/bin/env node
/*
  Before running, you must `npm install cheerio rimraf mkdirp`;

  Helpful Links:

  Web Audio API:
  - https://github.com/webaudio/web-audio-api
  - https://webaudio.github.io/web-audio-api/index.html

  IDL Stuff:
  ReSpec:
    - https://github.com/w3c/respec
    - https://www.w3.org/respec/examples/webidl-contiguous.html
  Bikeshed:
    - https://github.com/tabatkins/bikeshed
  Web IDL:
    - http://heycam.github.io/webidl/
    - https://github.com/heycam/webidl

  Libs:
  - https://github.com/cheeriojs/cheerio
  - https://github.com/isaacs/rimraf
  - https://github.com/substack/node-mkdirp

*/
var cheerio = require('cheerio');
var rimraf = require('rimraf');
var mkdirp = require('mkdirp');
var fs = require('fs');
var html = fs.readFileSync('./index.html', 'utf-8');
var $ = cheerio.load(html);
var idlMap = {};
var idlCount = 0;

var parseIDLs = function () {
  var idlFolder = `${__dirname}/../idl/`;
  rimraf.sync(idlFolder);
  $('.idl').each(function(i, elem) {
    var $this = $(this);
    var title = $this.attr('title');
    var titleInfo = title.split(' ');
    var type = titleInfo[0];
    if (type.indexOf('[Constructor') === 0) {
      type = 'Constructor';
    }
    if (!idlMap.hasOwnProperty(type)) {
      idlMap[type] = 0;
    }
    idlMap[type]++;
    var name = parseName(type, titleInfo);
    var contentHTML = $.html(elem); // $this.html();
    var contentIDL = contentHTML;
    idlCount++;
    if (type === 'enum') {
      contentIDL = parseEnum($this, elem, titleInfo, name);
    } else if (type === 'interface') {
    } else if (type === 'callback') {
    } else if (type === 'Constructor') {
    } else if (type === 'dictionary') {
    } else {
      console.error('Unknown Type');
    }
    $this.replaceWith(contentIDL);
    // write files
    var typeFolder = `${idlFolder}/${type}/`
    var filePrefix = `${typeFolder}/${name}`;
    mkdirp.sync(typeFolder);
    fs.writeFileSync(`${filePrefix}.html`, contentHTML, 'utf-8');
    fs.writeFileSync(`${filePrefix}.idl`, contentIDL, 'utf-8');
  });
  fs.writeFileSync(`${__dirname}/../index-new.html`, $.html(), 'utf-8');
};

var parseName = function(type, titleInfo) {
  var name = '[UNKNOWN]';
  switch (type) {
    case 'enum':
    case 'interface':
    case 'callback':
    case 'dictionary':
      name = titleInfo[1];
      break;
    case 'Constructor':
      name = titleInfo.join(' ').replace(':', '--');
      break;
  }
  return name;
};

var parseEnum = function ($el, el, titleInfo, name) {
  var keys = $el.find('> dt').map(function () {
    return $(this).text().trim();
  }).get();
  var values = $el.find('dd').map(function () {
    return $(this).html().trim();
  }).get();
  return `
<pre id="enum-${name}" class="idl">
enum ${name} {
    ${keys.map(JSON.stringify).join(',\n    ')}
};
</pre>
<table class="simple">
  <tr>
    <th colspan="2">Enumeration description:</th>
  </tr>
  ${keys.map((key, i) => {
    return `<tr>
    <td><dfn for="${name}">${key}</dfn></td>
    <td>${values[i]}</td>
</tr>`;
  }).join('\n    ')}
</table>
`.trim();
};

var getClasses = function () {
  var classes = [];
  $('*').each((i, elem) => {
    var $this = $(this);
    var { tagName, attribs } = elem;
    var attrs = Object.keys(attribs);
    if (attribs.hasOwnProperty('class')) {
      attribs.class.split(' ').forEach((item) => {
        if (item.length && classes.indexOf(item) === -1) {
          classes.push(item);
        }
      });
    }
  });
  return classes;
}

parseIDLs();
console.log(idlMap, idlCount);
console.log(getClasses());
