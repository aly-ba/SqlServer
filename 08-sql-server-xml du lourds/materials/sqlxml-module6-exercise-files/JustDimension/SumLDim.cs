using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Dimensions;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(
	Format.Native,
	IsInvariantToNulls=true,
	IsInvariantToOrder=true
	
	)]
public struct SumLDim
{
	int int0;
	int int1;
	int int2;
	int int3;
	void SaveSum(decimal d)
	{
		
		int[] ints = decimal.GetBits(d);
		int0 = ints[0];
		int1 = ints[1];
		int2 = ints[2];
		int3 = ints[3];
	}
	decimal GetSum()
	{
		int[] ints = new int[4];
		ints[0] = int0;
		ints[1] = int1;
		ints[2] = int2;
		ints[3] = int3;
		return new decimal(ints);
	}
	public void Init()
	{
		SaveSum(0M);
	}

	public void Accumulate(LDim Value)
	{
		if(!Value.IsNull)
		{
			SaveSum((Value.Inches.Value + GetSum()));
		}
	}

	public void Merge(SumLDim Group)
	{
		SaveSum(GetSum() + Group.GetSum());
	}

	public LDim Terminate()
	{
		LDim ldim = LDim.Parse("0 ft");
		ldim.Inches=GetSum();
		return ldim;
	}

}
