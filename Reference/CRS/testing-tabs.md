
bulleted list

<details>
<summary>My Favorite Resources for Understanding Coordinate Reference Systems</summary>
<br/>

My favorite resources for understanding this concept are:
<ul type = "circle">
  <li><a href="https://www.youtube.com/watch?v=kIID5FDi2JQ">this Vox video</a> on how areas of the globe must be distorted in order to render the 3-D ellipsoid of Earth into a 2D map</li>
  <li><a href="https://pro.arcgis.com/en/pro-app/latest/help/mapping/properties/coordinate-systems-and-projections.htm">this ArcGIS Pro article</a></li>
  <li>and <a href="https://ncxiao.github.io/map-projections/index.html">this interactive visualization</a> of how different projections warp the area of different parts of the world using <a href="https://en.wikipedia.org/wiki/Tissot%27s_indicatrix">Tissot's indicatrix</a> and Gedymin faces, by <a href="https://github.com/ncxiao">Ningchuan Xiao</a></li>
  <li>If you're not a fan of gifs you can click "pause" on that visualization, or use <a href="https://observablehq.com/@floledermann/projection-playground">this Map Projection Playground</a> by Florian Ledermann to visualize how different variables impact 2-D representations of area.</li>
</ul>
</details>


CSS


<style>
.tab {
  overflow: hidden;
  border: 1px solid #ccc;
  background-color: #f1f1f1;
}

.tab button {
  background-color: inherit;
  float: left;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 14px 16px;
  transition: 0.3s;
}

.tab button:hover {
  background-color: #ddd;
}

.tab button.active {
  background-color: #ccc;
}

.tabcontent {
  display: none;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-top: none;
}
</style>



Text introducing plots

<div class="tab">
  <button class="tablinks" onclick="openTab(event, 'Figure1')" id="defaultOpen">Mollweide Projection Cell Size</button>
  <button class="tablinks" onclick="openTab(event, 'Figure2')">OG CRS Cell Size</button>
</div>

<div id="Figure1" class="tabcontent">
  <img src="figs/cell_size_mollweide.png" alt="Mollweide Projection">
</div>

<div id="Figure2" class="tabcontent">
  <img src="figs/cell_size_og_crs.png" alt="Original CRS EPSG:4326">
</div>

<script>
function openTab(evt, tabName) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }
  document.getElementById(tabName).style.display = "block";
  evt.currentTarget.className += " active";
}

document.getElementById("defaultOpen").click();
</script>




> <details>
    <summary>My Favorite Resources for Understanding Coordinate Reference Systems</summary>
    <br>
    <p>My favorite resources for understanding this concept are [this Vox video](https://www.youtube.com/watch?v=kIID5FDi2JQ) on how areas of the globe must be distorted in order to render the 3-D ellipsoid of Earth into a 2D map, [this ArcGIS Pro article](https://pro.arcgis.com/en/pro-app/latest/help/mapping/properties/coordinate-systems-and-projections.htm), and [Ningchuan Xiao’s interactive visualization](https://ncxiao.github.io/map-projections/index.html) of how different projections warp the area of different parts of the world using [Tissot’s indicatrix](https://en.wikipedia.org/wiki/Tissot%27s_indicatrix) and Gedymin faces. If you’re not a fan of gifs you can click “pause” on that visualization, or use [this Map Projection Playground](https://observablehq.com/@floledermann/projection-playground) by Florian Ledermann to visualize how different variables impact 2-D representations of area.</p>
</details>
