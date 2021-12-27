pkgname=st
pkgver=0.8.4
pkgrel=1
pkgdesc='A simple virtual terminal emulator for X.'
arch=('x86_64')
license=('MIT')

url=https://st.suckless.org/
source=("https://dl.suckless.org/$pkgname/$pkgname-$pkgver.tar.gz"
	"combined.diff"
	)

sha256sums=('d42d3ceceb4d6a65e32e90a5336e3d446db612c3fbd9ebc1780bc6c9a03346a6'
	    'SKIP'
)

extractdir="$pkgname-$pkgver"

prepare() {
	patch --directory="$extractdir" < "$srcdir/combined.diff"

	cp "$srcdir/$extractdir/config.def.h" "$BUILDDIR"

	if [ -f "$BUILDDIR/config.h" ]
	then
		cp "$BUILDDIR/config.h" "$srcdir/$extractdir"
	fi
}

build() {
	make --directory="$extractdir"
}

package() {
	make --directory="$extractdir" DESTDIR="$pkgdir/" install
}
