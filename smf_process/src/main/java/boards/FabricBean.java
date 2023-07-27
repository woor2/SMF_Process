package boards;

public class FabricBean {
	
	private String batchNumber;
	private int specification;
	private int length;
	private  String pattern;
	private int rollAmount;
	
	public FabricBean() {
		
	}

	public FabricBean(String batchNumber, int specification, int length, String pattern, int rollAmount) {
		this.batchNumber = batchNumber;
		this.specification = specification;
		this.length = length;
		this.pattern = pattern;
		this.rollAmount = rollAmount;
	}

	public String getBatchNumber() {
		return batchNumber;
	}

	public void setBatchNumber(String batchNumber) {
		this.batchNumber = batchNumber;
	}

	public int getSpecification() {
		return specification;
	}

	public void setSpecification(int specification) {
		this.specification = specification;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public String getPattern() {
		return pattern;
	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

	public int getRollAmount() {
		return rollAmount;
	}

	public void setRollAmount(int rollAmount) {
		this.rollAmount = rollAmount;
	}

	@Override
	public String toString() {
		return "FabricBean [batchNumber=" + batchNumber + ", specification=" + specification + ", length=" + length
				+ ", pattern=" + pattern + ", rollAmount=" + rollAmount + "]";
	}
	

}
