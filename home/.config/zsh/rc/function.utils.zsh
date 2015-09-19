function degree2radian() {
    python -c "import math; print($1 * math.pi / 180.0)"
}
function radian2degree() {
    python -c "import math; print($1 * 180.0 / math.pi)"
}
