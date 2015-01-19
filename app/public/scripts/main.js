$(function() {

  if(window.addEventListener) {
    window.addEventListener("load", function() {
      setTimeout(function() {window.scrollTo(0,0.9)} ,0)
    });
  }

  // Initialize Parallax for the fun effects at the top of the page
  $('body').parallax({
    'elements': [
    {
      'selector': 'div.wrapouter',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 0,
            'multiplier': 0.015,
            'invert': true
          }
        }
      }
    },
    {
      'selector': 'div.outer',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 0,
            'multiplier': 0.02,
            'unit': '%'
          }
        }
      }
    },
    {
      'selector': 'div.inner',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 0,
            'multiplier': 0.02
          }
        }
      }
    },
    {
      'selector': 'div.cloud1',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 30,
            'multiplier': 0.01
          }
        }
      }
    },
    {
      'selector': 'div.cloud2',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 38,
            'multiplier': 0.03
          }
        }
      }
    },
    {
      'selector': 'div.cloud3',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 1000,
            'multiplier': 0.025
          }
        }
      }
    },
    {
      'selector': 'div.cloud4',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 1000,
            'multiplier': 0.01
          }
        }
      }
    },
    {
      'selector': 'div.moon',
      'properties': {
        'x': {
          'background-position-x': {
            'initial': 1100,
            'multiplier': 0.015
          }
        }
      }
    }
  ]
  });

  // Setup Canvas
  // Main canvas and context references
  var canvas;
  var ctx;

  // Frames per second
  var fps = 60.0;

  // Animations
  var animations = [ new taiPath() ];

  function taiPath() {

    // Control and anchor points
    this.points = [
    [ [261.0, 54.4], [74.0, -11.0], [57.7, 146.0], [123.8, 180.0] ],
    [ [123.8, 180.0], [190.0, 214.0], [200.5, 237.5], [200.5, 237.5] ]
    ];

    // Linear motion index
    this.linear = [
    [0, 0.00, 0.00], [0, 0.11, 0.14], [0, 0.25, 0.29], [0, 0.45, 0.43],
    [0, 0.68, 0.57], [0, 0.93, 0.71], [1, 0.22, 0.86], [1, 1.00, 1.00]
    ];

    // Segment T boundaries
    this.segmentT = [0.75, 1.00];

    this.lastValue = -1.0;
    this.x = 0;
    this.y = 0;
    this.orientation = 0.0;
    this.pathClock = new clock(5.00, 0.00, 1, false, 1, quintEaseOut, this.linear.length - 1, 1.00, 0.0000);

    // Update function
    this.update = updatePath;
  }

  function init() {

    // Set main canvas and context references
    canvas = document.getElementById("canvas");
    ctx = canvas.getContext("2d");

    // Initialize animations
    tai.followOrientation = -90.00 * Math.PI / 180.0;

    // Start animation clocks
    animations[0].pathClock.start();

    // Set animation timer
    setInterval(drawFrame, (1000 / fps));
  }

  function updateAnimations() {

    // Update animation clocks
    updateAllClocks();

    // Update animation paths
    var animationCount = animations.length;
    for (var i = 0; i < animationCount; i++) {
      animations[i].update();
    }
  }

  function drawFrame() {

    // Update animations
    updateAnimations();

    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    bg(ctx);

    ctx.save();
    ctx.translate(animations[0].x, animations[0].y);
    ctx.rotate(tai.followOrientation + animations[0].orientation);
    tai(ctx);
    ctx.restore();
  }

  function bg(ctx) {

    // bg/Path
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(268.5, 291.5);
    ctx.lineTo(0.0, 291.5);
    ctx.lineTo(0.0, 0.0);
    ctx.lineTo(268.5, 0.0);
    ctx.lineTo(268.5, 291.5);
    ctx.closePath();
    ctx.restore();
  }

  function tai(ctx) {

    // tai
    ctx.drawImage(document.getElementById("image1"), -40.0, -37.0);
  }

  init();
});
