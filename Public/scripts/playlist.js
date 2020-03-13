$(function() {
    $("#playlist li").on("click", function() {
        $("#player").attr({
            "src": $(this).attr("movieurl"),
            "poster": "",
            "autoplay": "autoplay"
        })
    })
    $("#player").attr({
        "src": $("#playlist li").eq(0).attr("movieurl"),
        "poster": $("#playlist li").eq(0).attr("moviesposter")
    })
});

(function () {
    var video = document.querySelector('#player');
  
    if (Hls.isSupported()) {
      var hls = new Hls();
      hls.loadSource('platlist');
      hls.attachMedia(video);
      hls.on(Hls.Events.MANIFEST_PARSED,function() {
        video.play();
      });
    }
    
    plyr.setup(video);
  })();