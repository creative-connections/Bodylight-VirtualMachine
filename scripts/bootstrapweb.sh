head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/jupyter"><div><u>Jupyter notebook</u> <ul><li> <u>/jupyter</u></li><li class="small">Installed at <code>/home/vagrant/jupyter</code></li></ul></div></a>
</body>
</html>
EOF

head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/composer/"><div><u>Bodylight.js Composer</u><ul><li><u>/composer/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Composer</code></li></ul></div></a>
<a href="/virtualbody/"><div><u>Virtual Body App</u><ul><li><u>/virtualbody/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
<a href="/components/"><div><u>Web Components</u><ul><li><u>/components/</u></li><li class="small">installed at <code>/home/vagrant/aurelia-bodylight-plugin</code></li></ul></div></a>
<a href="/webcomponents/"><div><u>Web Components Demo</u><ul><li><u>/webcomponents/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Components</code></li></ul></div></a>
<a href="/scenarios/"><div><u>Scenarios</u><ul><li><u>/scenarios/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
<a href="/compiler/"><div><u>Bodylight.js Compiler</u><ul><li><u>/compiler/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-FMU-Compiler</code></li></ul></div></a>
<a href="/editor/"><div><u>Bodylight Editor</u><ul><li><u>/editor/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Editor</code></li></ul></div></a>

</body>
</html>
EOF

head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<div><u>OpenModelica</u> <br/><ul>
    <li>In Jupyter notebook at <a href="/jupyter/">/jupyter/</a>
    <ul><li>Click <code>New</code></li><li>select <code>OpenModelica</code></li></ul></li>
    <li>Open virtual machine desktop<ul>
    <li>Open terminal emulator and type: </li>
    <li><code>OMEdit</code> - to launch Open Modelica Editor. </li>
    <li><code>omc</code> - to launch Open Modelica Compiler.</li>    
    </ul></li>
</ul></div>
</body>
</html>
EOF
