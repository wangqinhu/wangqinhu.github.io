---
title: Archive
layout: page
---

<ul class="listing">
{% for post in site.posts %}
  {% capture y %}{{post.date | date:"%Y"}}{% endcapture %}
  {% if year != y %}
    {% assign year = y %}
    <li class="listing-seperator"><time>{{ y }}</time></li>
  {% endif %}
  <li class="listing-item">
    <time datetime="{{ post.date | date_to_string }}">{{ post.date | date_to_string }}</time>
    <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
