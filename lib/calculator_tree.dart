class CalculatorTree {
	String node;
	CalculatorTree leftChild;
	CalculatorTree rightChild;
	CalculatorTree parentTree;

	CalculatorTree( node, leftChild, rightChild, [parentTree] ) {
		this.node = node;
		this.leftChild = leftChild;
		this.rightChild = rightChild;
		this.parentTree = parentTree;
	}
}