// gulpfile.js
const gulp  = require('gulp'),
    browserSync = require('browser-sync').create(),
    htmlmin = require('gulp-htmlmin'),
    nunjucksRender = require('gulp-nunjucks-render');
    image = require('gulp-image');

var sass = require('gulp-sass');
var cleanCSS = require('gulp-clean-css');
var del = require('del');

const PATHS = {
    output: 'dist',
    templates: 'src/templates',
    pages: 'src/pages',
    styles: 'src/sass',
    css: 'src/css',
    fonts: 'src/fonts',
    img: 'src/images',
    fonts: 'src/fonts'
}


gulp.task('image', function () {
  gulp.src(PATHS.img + '/**')
    .pipe(image())
    .pipe(gulp.dest(PATHS.output + '/images'));
});

gulp.task('fonts', function(){
  console.log('Moving fonts...');
  return gulp.src(PATHS.fonts + "/.*")
      .pipe(gulp.dest(PATHS.output + '/fonts'))
      .pipe(browserSync.reload({
        stream: true
    }));
});

gulp.task('minify-css', function() {
  console.log('Minifying CSS files..');
  return gulp.src(PATHS.css + '/*.css')
    .pipe(cleanCSS({compatibility: 'ie8'}))
    .pipe(gulp.dest( PATHS.output + '/css'))
    .pipe(browserSync.reload({
      stream: true
    }));
});

gulp.task('sass', function () {
  console.log('Rendering SASS files..');
  return gulp.src(PATHS.styles + '/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(PATHS.output + '/css'))
    .pipe(browserSync.reload({
      stream: true
    }));
});

// writing up the gulp nunjucks task
gulp.task('nunjucks', function() {
    console.log('Rendering nunjucks files..');
    return gulp.src(PATHS.pages + '/**/*.+(html|js|css)')
        .pipe(nunjucksRender({
          path: [PATHS.templates],
          watch: true,
        }))
        .pipe(gulp.dest(PATHS.output))
        .pipe(browserSync.reload({
          stream: true
        }));
});

gulp.task('browserSync', function() {
    browserSync.init({
        server: {
            baseDir: PATHS.output
        },
    });
});

gulp.task('fonts', function() {
  return gulp.src(PATHS.fonts + '/**/*')
  .pipe(gulp.dest('dist/fonts'))
})


gulp.task('watch',['browserSync', 'sass', 'minify-css'], function() {
    // trigger Nunjucks render when pages or templates changes
    gulp.watch([PATHS.pages + '/**/*.+(html|js|css)', PATHS.templates + '/**/*.+(html|js|css)'], ['nunjucks'])
    gulp.watch(PATHS.styles + '/*.scss', ['sass']);
    gulp.watch(PATHS.css + '/*.css', ['minify-css']);
    gulp.watch(PATHS.img + '/**', ['image']);
    // reload browsersync when `dist` changes
    // gulp.watch(PATHS.output + '/**').on('change', browserSync.reload);
});

gulp.task('minify', function() {
  return gulp.src(PATHS.output + '/*.html')
    .pipe(htmlmin({
        collapseWhitespace: true,
        cssmin: true,
        jsmin: true,
        removeOptionalTags: true,
        removeComments: false
    }))
    .pipe(gulp.dest(PATHS.output));
});

gulp.task('clean:dist', function() {
  return del.sync(PATHS.output);
})

// run browserSync auto-reload together with nunjucks auto-render
gulp.task('auto', ['browserSync', 'watch']);

// Build all
gulp.task('build', [`clean`, `sass`, `minify-css`, `image`, `nunjucks`], function (){
  console.log('Building all files');
})
