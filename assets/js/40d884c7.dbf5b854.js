"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[881],{4137:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>g});var r=n(7294);function i(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,i=function(e,t){if(null==e)return{};var n,r,i={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(i[n]=e[n]);return i}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var c=r.createContext({}),s=function(e){var t=r.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(c.Provider,{value:t},e.children)},d="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},f=r.forwardRef((function(e,t){var n=e.components,i=e.mdxType,a=e.originalType,c=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),d=s(n),f=i,g=d["".concat(c,".").concat(f)]||d[f]||p[f]||a;return n?r.createElement(g,o(o({ref:t},u),{},{components:n})):r.createElement(g,o({ref:t},u))}));function g(e,t){var n=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var a=n.length,o=new Array(a);o[0]=f;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l[d]="string"==typeof e?e:i,o[1]=l;for(var s=2;s<a;s++)o[s]=n[s];return r.createElement.apply(null,o)}return r.createElement.apply(null,n)}f.displayName="MDXCreateElement"},3892:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>c,contentTitle:()=>o,default:()=>p,frontMatter:()=>a,metadata:()=>l,toc:()=>s});var r=n(7462),i=(n(7294),n(4137));const a={id:"align",sidebar_position:2,title:"Align"},o=void 0,l={unversionedId:"Align/align",id:"Align/align",title:"Align",description:"Vision",source:"@site/docs/1-Align/1-Align.md",sourceDirName:"1-Align",slug:"/Align/",permalink:"/solution-mq-rdqm-hadr/Align/",draft:!1,editUrl:"https://github.com/ibm-client-engineering/solution-mq-rdqm-hadr.git/docs/1-Align/1-Align.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{id:"align",sidebar_position:2,title:"Align"},sidebar:"tutorialSidebar",previous:{title:"Innovate",permalink:"/solution-mq-rdqm-hadr/category/innovate"},next:{title:"Refine",permalink:"/solution-mq-rdqm-hadr/Align/refine"}},c={},s=[{value:"Vision",id:"vision",level:2},{value:"Background and Intent",id:"background-and-intent",level:2},{value:"Overview",id:"overview",level:2}],u={toc:s},d="wrapper";function p(e){let{components:t,...n}=e;return(0,i.kt)(d,(0,r.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h2",{id:"vision"},"Vision"),(0,i.kt)("p",null,"This section establishes the strategic foundation for the project"),(0,i.kt)("h1",{id:"introduction-and-intent"},"Introduction and Intent"),(0,i.kt)("h2",{id:"background-and-intent"},"Background and Intent"),(0,i.kt)("p",null,"This Solution Document covers the following"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Validate MQIPT architecture for Guaranteed message delivery using IBM MQ"),(0,i.kt)("li",{parentName:"ul"},"Validate the function of MQIPT as a secure MQ proxy inn the DMZ"),(0,i.kt)("li",{parentName:"ul"},"High Availability and Disaster Recovery across multiples zones and regions using RDQM"),(0,i.kt)("li",{parentName:"ul"},"IBM MQ and MQIPT security constructs (LDAP authentication, MQIPT mTLS, SSL Peering, Channel security)")),(0,i.kt)("h2",{id:"overview"},"Overview"),(0,i.kt)("p",null,"This solution architecture demonstrates how you can deploy the Replicated Data Queue Manager in a Highly Available, Disaster Recovery enabled configuration across two regions that are interconnected/peered by a construct like the Transit Gateway (MZRs in IBM Cloud or Regions in AWS)."),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"MQIPT nodes are setup in a DMZ subnet that is able to accept traffic from the internet on port ",(0,i.kt)("inlineCode",{parentName:"li"},"1501")," and ",(0,i.kt)("inlineCode",{parentName:"li"},"1502"),". The IPT nodes proxy the traffic to an Application Load Balancer that in turn will direct the traffic to the active RDQM instance in one of the three active zones.")))}p.isMDXComponent=!0}}]);